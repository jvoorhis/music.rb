module Music
  module Performer
    
    class Base
      def self.perform(music)
        new.perform(music)
      end
      
      def perform(music, context = Context.default)
        music.perform(self, context)
      end
      
      def perform_group(music, context)
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
