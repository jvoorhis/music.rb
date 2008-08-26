# music.rb is symbolic musical computation for Ruby.
# Copyright (C) 2008 Jeremy Voorhis <jvoorhis@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'forwardable'
require 'music/temporal'
require 'music/timeline'
require 'music/pretty_printer'

module Music
  module Arrangement
    
    class Base
      # Return the empty MusicObject.
      def self.none; silence(0) end
      def none; self.class.none end
      
      # Sequential composition.
      def seq(other)
        Seq.new(self, other)
      end
      alias & seq
      
      # Parallel (concurrent) composition.
      def par(other)
        Par.new(self, other)
      end
      alias | par
      
      # Parallel composition. The duration of the longer sequence is truncated
      # to match the duration of the shorter one.
      def /(other)
        d = [duration, other.duration].min
        take(d) | other.take(d)
      end
      
      # Sequentially compose a sequence with itself n times.
      def repeat(n)
        unless n.kind_of?(Integer)
          raise TypeError, "Expected Integer, got #{n.class}."
        end
        
        unless n >= 0
          raise ArgumentError, "Expected non-negative Integer, got #{n}."
        end
        
        if n.zero? then none
        else        
          (1..(n-1)).inject(self) { |mus,rep| mus & self }
        end
      end
      alias * repeat
      
      # Delay a sequence by composing it with Silence.
      def delay(dur)
        silence(dur) & self
      end
      
      def transpose(hs)
        map { |a| a.transpose(hs) }
      end
      
      # Test for equivalence. Two MusicObject sequences are _equivalent_ if they
      # produce idential Timelines when interpreted.
      def ===(mus)
        self.to_timeline == mus.to_timeline
      end
      
      def to_timeline
        TimelinePerformer.perform(self)
      end
      
      def inspect
        PrettyPrinter.perform(self)
      end
    end
    
    class Seq < Base
      attr_reader :left, :right, :duration
      
      def initialize(left, right)
        @left, @right = left, right
        @duration = @left.duration + @right.duration
      end
      
      def ==(other)
        case other
          when Seq
            left == other.left && right == other.right
          else false
        end
      end
      
      def map(&block)
        self.class.new(left.map(&block), right.map(&block))
      end
      
      def perform(performer, c0)
        l  = left.perform(performer, c0)
        c1 = c0.advance(left.duration)
        r  = right.perform(performer, c1)
        performer.perform_seq(l, r, c0)
      end
      
      def take(d)
        dl = left.duration
        if d <= dl
          left.take(d)
        else
          left & right.take(d - dl)
        end
      end
      
      def drop(d)
        dl = left.duration
        if d <= dl
          left.drop(d) & right
        else
          right.drop(d-dl)
        end
      end
      
      def reverse
        self.class.new(right.reverse, left.reverse)
      end
    end
    
    class Par < Base
      attr_reader :top, :bottom, :duration
      
      def initialize(top, bottom)
        dt = top.duration
        db = bottom.duration
        
        if dt == db
          @top, @bottom = top, bottom
        elsif dt > db
          @top    = top
          @bottom = bottom & rest(dt-db)
        elsif db > dt
          @top    = top & rest(db-dt)
          @bottom = bottom
        end
        
        @duration = [@top.duration, @bottom.duration].max
      end
      
      def ==(other)
        case other
          when Par
            top == other.top && bottom == other.bottom
          else false
        end
      end
      
      def map(&block)
        self.class.new(top.map(&block), bottom.map(&block))
      end
      
      def perform(performer, c0)
        t  = performer.perform(top, c0)
        b  = performer.perform(bottom, c0)
        performer.perform_par(t, b, c0)
      end
      
      def take(d)
        top.take(d) | bottom.take(d)
      end
      
      def drop(d)
        top.drop(d) | bottom.drop(d)
      end
      
      def reverse
        self.class.new(top.reverse, bottom.reverse)
      end
    end
    
    class Group < Base
      extend Forwardable
      def_delegators :@music, :duration
      attr_reader :music, :attributes
      
      def initialize(music, attributes = {})
        @music, @attributes = music, attributes
      end
      
      def ==(other)
        case other
          when Group: music == other.music
          else false
        end
      end
      
      def map(&block)
        self.class.new(music.map(&block), attributes)
      end
      
      def take(d)
        self.class.new(music.take(d), attributes)
      end
      
      def drop(d)
        self.class.new(music.drop(d), attributes)
      end
      
      def reverse
        self.class.new(music.reverse, attributes)
      end
      
      def perform(performer, c0)
        c1 = c0.push(attributes)
        m  = music.perform(performer, c1)
        performer.perform_group(m, c0)
      end
    end
    
    class Item < Base
      attr_reader :item
      
      extend Forwardable
      def_delegators :@item, :duration, :perform
      
      def initialize(item)
        @item = item
      end
      
      def ==(other)
        case other
          when Item: item == other.item
          else false
        end
      end
      
      def map; self.class.new yield(item) end
      
      def take(d)
        if d <= 0 then none
        else
          self.class.new(item.take(d))
        end
      end
      
      def drop(d)
        if d >= duration then none
        else
          self.class.new(item.drop(d))
        end
      end
      
      def reverse; self end
    end
  end
end
