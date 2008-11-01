module Music
  module Interpreter
    
    class Base
      def self.eval(music)
        new.eval(music)
      end
      
      def eval(music, context = Context.default(music.duration))
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
      
      def self.default(duration)
        new(0, { :section_start => 0, :section_duration => duration})
      end
      
      def initialize(time, attrs)
        @time, @attributes = time, attrs
      end
      
      def [](name) attributes[name] end
      
      def phase
        (@time - @attributes[:section_start]) / @attributes[:section_duration].to_f
      end
      
      def advance(dur)
        self.class.new(time + dur, attributes)
      end
      
      def push(a0)
        a1 = attributes.merge(a0)
        self.class.new(time, a1)
      end
      
      def accept(a0)
        names = a0.keys | self.attributes.keys
        push(names.inject({}) { |a1, name|
          a1.merge name => case new = self.attributes[name]
            # If a0 yields a Gen, apply it
            when Env: new.apply(name, a0[name], self)
            # otherwise, inherit the attribute value from a0 if
            # we haven't defined it
            else self.attributes[name] || a0[name]
          end
        })
      end
    end
  end
end
