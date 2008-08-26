require 'music/attributes'
require 'music/temporal'
require 'music/pretty_printer'
require 'music/timeline'

module Music
  module Objects
    include Attributes
    include Temporal
    
    class Base
      def self.none
        Silence.new(0)
      end
      
      def none
        self.class.none
      end
      
      def inspect
        PrettyPrinter.perform(self)
      end
      
      def to_timeline
        TimelinePerformer.perform(self)
      end
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
        performer.perform_silence(self, c)
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
          self.class.new(duration - d.clip(0..duration))
        end
      end
      
      def read_attribute(name) attributes[name] end
      
      def update_attribute(name, val)
        self.class.new(duration, attributes.merge(name => val))
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
        n1 = inherit(c.attributes)
        performer.perform_note(n1, c)
      end
      
      def inherit(attrs)
        Note.new(pitch, duration, attrs.merge(attributes))
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
          self.class.new(pitch, duration - d.clip(0..duration), attributes)
        end
      end
      
      def read_attribute(name) attributes[name] end
      
      def update_attribute(name, val)
        self.class.new(pitch, duration, attributes.merge(name => val))
      end
    end
  end
end
