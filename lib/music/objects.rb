require 'music/attributes'
require 'music/temporal'
require 'music/pretty_printer'
require 'music/timeline'

module Music
  module Objects
    
    # The identity under parallel and sequential composition.
    def none; Silence.new(0) end
    module_function :none
    
    class Base
      include Attributes
      include Temporal
      
      def inspect
        PrettyPrinter.perform(self)
      end
      
      def to_timeline
        TimelinePerformer.perform(self)
      end
    end
    
    # Remain silent for the duration.
    class Silence < Base
      attr_reader :attributes
      
      def initialize(duration, attributes = {})
        @attributes = attributes.merge(:duration => duration)
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
      
      def read(name)
        if @attributes.key?(name)
          @attributes[name]
        else
          warn "No attribute #{name} for #{inspect}."
        end
      end
      
      def update(name, val)
        a = @attributes.merge(name => val)
        d = a[:duration]
        self.class.new(d, a)
      end
    end
    Rest = Silence unless defined?(Rest) # Type alias for convenience
    
    # A note has a steady pitch and a duration.
    class Note < Base
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
      
      def perform(performer, c)
        n1 = inherit(c.attributes)
        performer.perform_note(n1, c)
      end
      
      def inherit(attrs)
        a = attrs.merge(@attributes)
        p, d = a.values_at(:pitch, :duration)
        self.class.new(p, d, a)
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
          update(:duration, (duration - time).clip(0 .. duration))
        end
      end
      
      def read(name)
        if @attributes.key?(name)
          @attributes[name]
        else
          warn "No attribute #{name} for #{inspect}."
        end
      end
      
      def update(name, val)
        a = @attributes.merge(name => val)
        p, d = a.values_at(:pitch, :duration)
        self.class.new(p, d, a)
      end
    end
  end
end
