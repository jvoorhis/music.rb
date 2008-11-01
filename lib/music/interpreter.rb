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
      
      def advance(dur)
        self.class.new(time + dur, attributes)
      end
      
      def push(a0)
        a1 = @attributes.merge(a0)
        self.class.new(time, a1)
      end
    end
  end
end
