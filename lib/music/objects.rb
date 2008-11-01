require 'music/attributes'
require 'music/temporal'
require 'music/pretty_printer'
require 'music/timeline'

module Music
  module Objects
    
    class Base
      include Attributes
      include Temporal
      
      def inspect
        PrettyPrinter.eval(self)
      end
      alias to_s inspect
      
      def to_timeline
        TimelineInterpreter.eval(self)
      end
      
      def read(name)
        if @attributes.key?(name)
          @attributes[name]
        else
          warn "No attribute #{name} for #{inspect}."
        end
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
    class Rest < Base
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
      
      def eval(interpreter, c)
        interpreter.eval_rest(self, c)
      end
      
      def update(name, val)
        a = @attributes.merge(name => val)
        d = a[:duration]
        self.class.new(d, a)
      end
    end
    
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
      
      def eval(interpreter, c)
        n1 = inherit(c.attributes)
        interpreter.eval_note(n1, c)
      end
      
      def inherit(attrs)
        a = attrs.merge(@attributes)
        p, d = a.values_at(:pitch, :duration)
        self.class.new(p, d, a)
      end
      
      def update(name, val)
        a = @attributes.merge(name => val)
        p, d = a.values_at(:pitch, :duration)
        self.class.new(p, d, a)
      end
    end
  end
end
