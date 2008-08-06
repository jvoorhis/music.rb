module Music
  module Objects
    
    class Base
      def self.none; Silence.new(0) end
      def none; self.class.none end
    end
    
    # Remain silent for the duration.
    class Silence < Base
      attr_reader :duration, :attributes
      
      def initialize(duration, attributes = {})
        @duration, @attributes = duration, attributes
      end
      
      def ==(other)
        case other
          when Silence: duration == other.duration
          else false
        end
      end
      
      def transpose(interval) self end
      
      def perform(performer, c)
        [ performer.perform_silence(self, c), c.advance(duration) ]
      end
      
      def take(d)
        if d <= 0 then none
        else
          self.class.new([duration, d].min)
        end
      end
      
      def drop(d)
        if d >= duration then none
        else
          clipped = d > 0 ? d : 0
          self.class.new([duration-d.clip_lo(0), 0].max)
        end
      end
    end
    Rest = Silence unless defined?(Rest) # Type alias for convenience
    
    # A note has a steady pitch and a duration.
    class Note < Base
      attr_reader :pitch, :duration, :attributes
      
      def initialize(pitch, duration, attributes = {})
        @pitch      = pitch
        @duration   = duration
        @attributes = attributes
      end
      
      def ==(other)
        case other
          when Note
            [pitch, duration] == [other.pitch, other.duration]
          else false
        end
      end
      
      def transpose(interval)
        self.class.new(pitch + interval, duration, attributes)
      end
      
      def perform(performer, c)
        [ performer.perform_note(self, c), c.advance(duration) ]
      end
      
      def take(d)
        if d <= 0 then none
        else
          self.class.new(pitch, [duration, d].min, attributes)
        end
      end
      
      def drop(d)
        if d >= duration then none
        else
          self.class.new(pitch, [duration-d.clip_lo(0), 0].max, attributes)
        end
      end
    end
  end
end
