module Music
  
  class Event
    include Comparable
    
    attr_reader :time, :object
    
    def initialize(time, obj)
      @time, @object = time, obj
    end
    
    def ==(other)
      [time, object] == [other.time, other.object]
    end
    
    def <=>(other)
      time <=> other.time
    end
  end
  
  class Timeline
    extend Forwardable
    include Enumerable
    
    attr_reader :events
    
    def self.[](*events) new(events.flatten) end
    
    def initialize(events) @events = events end
    
    def merge(other)
      self.class.new((events + other.events).sort)
    end
    
    def [](i)
      if event = @events[i] then event.object end
    end
    
    def +(other)
      self.class.new(events + other.events)
    end
    
    def ==(other)
      events == other.events
    end
    
    def each
      events.each do |e|
        yield e.object
      end
    end
    
    def each_with_time
      events.each do |e|
        yield e.object, e.time
      end
    end
    
    def to_timeline; self end
  end
  
  class TimelineInterpreter < Interpreter::Base
    def eval_seq(left, right, context)
      left + right
    end
    
    def eval_par(top, bottom, context)
      top.merge(bottom)
    end
    
    def eval_note(note, context)
      Timeline.new([Event.new(context.time, note)])
    end
    
    def eval_rest(rest, context)
      Timeline.new([])
    end

    def eval_controller(ctl, context)
      Timeline.new([Event.new(context.time, ctl)])
    end
  end
end
