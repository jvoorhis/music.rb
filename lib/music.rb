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

require 'prelude'
require 'forwardable'
require 'music/duration'
require 'music/smf_writer'

module Music
  include Duration
  
  module_function
  # Convert midi note numbers to hertz
  def mtof(pitch)
    440.0 * (2.0 ** ((pitch.to_f-69)/12))
  end
  
  # Convert hertz to midi note numbers
  def ftom(pitch)
    (69 + 12 * (Math.log2(pitch / 440.0))).round
  end
  
  # Cast pitch value as a midi pitch number.
  def MidiPitch(pitch)
    case pitch
      when Integer then pitch
      when Float then ftom(pitch)
      else raise ArgumentError, "Cannot cast #{pitch.class} to midi."
    end
  end
  
  # Cast pitch value as hertz.
  def Hertz(pitch)
    case pitch
      when Integer then mtof(pitch)
      when Float then pitch
      else raise ArgumentError, "Cannot cast #{pitch.class} to hertz."
    end
  end
  
  # Construct a Note.
  def note(pit, dur=1, vel=100)
    Note.new(pit, dur, vel)
  end
  
  # Construct a Silence.
  def silence(dur=1)
    Silence.new(dur)
  end
  alias rest silence
  
  # Compose a list of MusicObjects sequentially.
  def line(*objs)
    objs.inject { |a, b| a & b }
  end
  
  # Compose a list of MusicObjects in parallel.
  def chord(*objs)
    objs.inject { |a, b| a | b }
  end
  
  class Pitch
    attr_reader :pitch_class, :octave
    def initialize(pc, oct)
      @pitch_class, @octave = pc, oct
    end
  end
  
  class PitchClass
    include Comparable
    
    def self.for(pitch)
      PITCH_CLASSES.detect { |pc| pc.ord == pitch % 12 }
    end
    
    attr_reader :name, :ord
    
    def initialize(name, ord)
      @name, @ord = name, ord
    end
    
    def <=>(pc) ord <=> pc.ord end
    
    def to_s; name.to_s end
    
    # Western pitch classes.
    PITCH_CLASSES = [
      new(:c, 0), new(:cs, 1),
      new(:d, 2), new(:ds, 3),
      new(:e, 4),
      new(:f, 5), new(:fs, 6),
      new(:g, 7), new(:gs, 8),
      new(:a, 9), new(:as, 10),
      new(:b, 11)
    ] unless defined?(PITCH_CLASSES)
  end
  
  class MusicObject
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
    
    def repeat(n)
      raise TypeError, "Expected Integer, got #{n.class}." unless Integer === n
      raise ArgumentError, "Expected non-negative Integer, got #{n}." unless n >= 0
      if n.zero? then Silence.new(0)
      else        
        (1..(n-1)).inject(self) { |mus,rep| mus & self }
      end
    end
    alias * repeat
    
    def delay(dur)
      Silence.new(dur) & self
    end
    
    def to_a; [self] end
  end
  
  class Seq < MusicObject
    attr_reader :left, :right
    
    def initialize(left, right)
      @left, @right = left, right
    end
    
    def ==(other)
      case other
        when Seq
          left == other.left && right == other.right
        else false
      end
    end
    
    def duration
      left.duration + right.duration
    end
    
    def perform(performer, c0)
      p1, c1 = left.perform(performer, c0)
      p2, c2 = right.perform(performer, c1)
      [ p1 + p2, Context[c2.time, c0.attributes] ]
    end
    
    def transpose(hs)
      @left.transpose(hs) & @right.transpose(hs)
    end
    
    def to_a
      left.to_a + right.to_a
    end
  end
  
  class Par < MusicObject
    attr_reader :top, :bottom
    
    def initialize(top, bottom)
      @top, @bottom = top, bottom
    end
    
    def ==(other)
      case other
        when Par
          top == other.top && bottom == other.bottom
        else false
      end
    end
    
    def duration
      [top.duration, bottom.duration].max
    end
    
    def perform(performer, c0)
      p1, c1 = top.perform(performer, c0)
      p2, c2 = bottom.perform(performer, c0)
      [ p1.merge(p2), Context[[c1.time, c2.time].max, c0.attributes] ]
    end
    
    def transpose(hs)
      @top.transpose(hs) | @bottom.transpose(hs)
    end
  end
  
  class Group < MusicObject
    extend Forwardable
    def_delegators :@music, :duration
    attr_reader :music, :attributes
    
    def initialize(music, attributes = {})
      @music, @attributes = music, attributes
    end
    
    def ==(other)
      case other
        when Group: @music == other.music
        else false
      end
    end
    
    def transpose(hs)
      self.class.new(@music.transpose(hs), @attributes)
    end
  end
  
  # Remain silent for the duration.
  class Silence < MusicObject
    attr_reader :duration, :attributes
    
    def initialize(duration, attributes = {})
      @duration, @attributes = duration, attributes
    end
    
    def ==(other)
      case other
        when Silence: @duration == other.duration
        else false
      end
    end
    
    def perform(performer, c)
      [ performer.perform_silence(self, c), c.advance(@duration) ]
    end
    
    def transpose(hs); self end
  end
  Rest = Silence unless defined?(Rest) # Type alias for convenience
  
  # A note has a steady pitch and a duration.
  class Note < MusicObject
    attr_reader :pitch, :duration, :effort, :attributes
    
    def initialize(pitch, duration, effort, attributes = {})
      @pitch      = pitch
      @duration   = duration
      @effort     = effort
      @attributes = attributes
    end
    
    def ==(other)
      case other
        when Note
          [@pitch, @duration, @effort] == [other.pitch, other.duration, other.effort]
        else false
      end
    end
    
    def perform(performer, c)
      [ performer.perform_note(self, c), c.advance(@duration) ]
    end
    
    def transpose(hs)
      self.class.new(@pitch+hs, @duration, @effort)
    end
  end
  
  class Event
    include Comparable
    
    attr_reader :time, :object
    
    def initialize(time, obj)
      @time, @object = time, obj
    end
    
    def <=>(ev)
      @time <=> ev.time
    end
  end
  
  class Timeline
    extend Forwardable
    include Enumerable
    
    attr_reader :events
    def_delegators :@events, :each
    
    def self.[](*events) new(events.flatten) end
    def initialize(events) @events = events end
    def merge(other)
      Timeline[ (@events + other.events).sort ]
    end
    def +(other)
      Timeline[ (@events + other.events) ]
    end
  end
  
  class Context < Struct.new(:time, :attributes)
    def self.default; new(0, {}) end
    def advance(dur)
      self.class[time + dur, attributes]
    end
  end
  
  class Performer
    def perform(score)
      score.perform(self, Context.default).first
    end
    
    def perform_note(note, context)
      Timeline[ Event.new(context.time, note) ]
    end
    
    def perform_silence(silence, context) Timeline[] end
  end
end
