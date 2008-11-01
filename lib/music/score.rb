require 'forwardable'
require 'music/attributes'
require 'music/temporal'
require 'music/timeline'
require 'music/pretty_printer'

module Music
  module Score
    
    class Base
      include Temporal
      
      # Return the empty MusicObject.
      def self.none; rest(0) end
      def none; self.class.none end
      
      # Sequential composition.
      def &(other)
        Seq.new(self, other)
      end
      
      # Parallel (concurrent) composition.
      def |(other)
        Par.new(self, other)
      end
      
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
      
      # Delay a sequence by composing it with a Rest.
      def delay(dur)
        rest(dur) & self
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
        TimelineInterpreter.eval(self)
      end
      
      def inspect
        PrettyPrinter.eval(self)
      end
      alias to_s inspect
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
      
      def eval(interpreter, c0)
        l  = left.eval(interpreter, c0)
        c1 = c0.advance(left.duration)
        r  = right.eval(interpreter, c1)
        interpreter.eval_seq(l, r, c0)
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
      
      def eval(interpreter, c0)
        t  = interpreter.eval(top, c0)
        b  = interpreter.eval(bottom, c0)
        interpreter.eval_par(t, b, c0)
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
    
    class Section < Base
      extend Forwardable
      def_delegators :@music, :duration
      attr_reader :music, :attributes
      
      def initialize(music, attributes = {})
        @music, @attributes = music, attributes
      end
      
      def ==(other)
        case other
          when Section: music == other.music
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
      
      def eval(interpreter, c0)
        c1 = c0.push(attributes)
        m  = music.eval(interpreter, c1)
        interpreter.eval_section(m, c0)
      end
    end
    
    class ScoreObject < Base
      include Attributes
      include Temporal
      
      def map; yield self end
      
      def reverse; self end
      
      def inspect
        PrettyPrinter.eval(self)
      end
      alias to_s inspect
      
      def to_timeline
        TimelineInterpreter.eval(self)
      end
      
      def read(name)
        @attributes[name]
      end
      
      def take(time)
        if time <= 0 then none
        else
          update(:duration, [time, duration].min)
        end
      end
      
      def drop(time)
        if time >= duration then none
        else
          update(:duration, (duration - time).clip(0..duration))
        end
      end
    end
    
    # Remain silent for the duration.
    class Rest < ScoreObject
      attr_reader :attributes
      
      def initialize(duration, attributes = {})
        @attributes = attributes.merge(:duration => duration)
      end
      
      def ==(other)
        case other
          when Rest: duration == other.duration
          else false
        end
      end
      
      def transpose(interval) self end
      
      def eval(interpreter, context)
        interpreter.eval_rest(self, context)
      end
      
      def update(name, val)
        a = @attributes.merge(name => val)
        d = a[:duration]
        self.class.new(d, a)
      end
    end
    
    # A note has a pitch and a duration.
    class Note < ScoreObject
      attr_reader :attributes
      
      def initialize(pitch, duration, attrs = {})
        @attributes = attrs.merge(:pitch => pitch, :duration => duration)
      end
      
      def ==(other)
        case other
          when Note
            [pitch, duration] == [other.pitch, other.duration]
          else false
        end
      end
      
      def transpose(interval)
        update(:pitch, pitch + interval)
      end
      
      def eval(interpreter, context)
        n1, c1 = inherit(context)
        interpreter.eval_note(n1, c1)
      end
      
      def update(name, val)
        a = attributes.merge(name => val)
        p, d = a.values_at(:pitch, :duration)
        self.class.new(p, d, a)
      end
      
      private
        def inherit(context)
          c1 = context.accept(attributes)
          p1, d1 = c1.attributes.values_at(:pitch, :duration)
          [self.class.new(p1, d1, c1.attributes), c1]
        end
    end
  end
end
