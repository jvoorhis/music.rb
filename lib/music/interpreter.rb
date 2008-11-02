module Music
  module Interpreter
    
    class Base
      def self.eval(music)
        new.eval(music)
      end
      
      def eval(music, context = nil)
        context ||= Context.init( Scope.new(0, music.duration, {}) )
        music.eval(self, context)
      end
      
      # Default implementation: sections have no special meaning besides
      # inheritance of attributes.
      def eval_section(music, context)
        music
      end
    end
    
    class Context
      attr_reader :time
      
      def self.init(scope)
        new(0, [scope])
      end
      
      def initialize(time, scopes)
        @time, @scopes = time, scopes
      end
      
      def keys
        @keys ||= @scopes.inject([]) { |ns, s| ns | s.attributes.keys }
      end
      
      def attributes
        @attributes ||= begin
          @scopes.inject({}) do |as, scope|
            keys.inject(as) do |as_, key|
              a1 = scope.attributes[key]
              a2 = as_[key]
              as_.merge key => case a1
                when Env: a1.apply(a2, phase)
                else a1 || a2
              end
            end
          end
        end
      end
      
      def [](key) attributes[key] end
      
      def phase
        (@time - top.offset) / top.duration.to_f
      end
      
      def advance(dur)
        self.class.new(time + dur, @scopes)
      end
      
      def push(scope)
        self.class.new(time, [scope, *@scopes])
      end
      
      def accept(attributes)
        push(Scope.new(top.offset, top.duration, attributes))
      end
      
      private
        def top; @scopes.first end
    end
  end
  
  class Scope
    attr_reader :offset, :duration, :attributes
    
    def initialize(offset, duration, attributes)
      @offset, @duration, @attributes = offset, duration, attributes
    end
  end
end
