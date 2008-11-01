module Music
  module Interpreter
    
    class Base
      def self.eval(music)
        new.eval(music)
      end
      
      def eval(music, context = Context.default)
        music.eval(self, context)
      end
      
      # Default implementation: sections have no special meaning besides
      # inheritance of attributes.
      def eval_section(music, context)
        music
      end
    end
    
    class Context
      attr_reader :time, :attributes
      
      def self.default; new(0, {}) end
      
      def initialize(time, attrs)
        @time, @attributes = time, attrs
      end
      
      def [](name) attributes[name] end
      
      def advance(dur)
        self.class.new(time + dur, attributes)
      end
      
      def push(a0)
        a1 = attributes.merge(a0)
        self.class.new(time, a1)
      end
      
      def accept(attrs)
        inherited = push(attributes.merge(attrs))
        push(inherited.attributes.inject({}) do |hsh, (name, val)|
          hsh.merge(name => val.attr_eval(inherited))
        end)
      end
    end
  end
end
