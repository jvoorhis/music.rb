module Music
  module Performer
    
    class Base
      def self.perform(score)
        new.perform(score)
      end
      
      def perform(score, context = Context.default)
        score.perform(self, context)
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
      
      def push(values)
        t = values[:time] || 0
        a = values[:attributes] || values[:attrs] || {}
        self.class.new(t, a)
      end
    end
  end
end
