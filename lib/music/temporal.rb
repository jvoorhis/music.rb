module Music
  # A mixin for implementing temporal objects. A temporal object must have a
  # numeric #duration, and respond to #take and #drop. Temporal objects may
  # also be reversible.
  module Temporal
    # Slice an object by time. With a scalar, positive time value, it
    # behaves as @item.take(time)@. With a negative, scalar time, it acts as
    # @item.drop(item.duration-time)@. When given a range, it returns the
    # points in time between the first and second endpoints. The value of
    # the first endpoint must be greater than the second.
    def slice(dur)
      num2idx = proc do |n|
        n < 0 ? n + duration : n
      end
      
      case dur
        when Numeric
          slice(0..dur)
        when Range
          d1, d2 = num2idx[dur.begin], num2idx[dur.end]
          take(d2).drop(d1)
      end
    end
    alias [] slice
    
    # Default implementation; assume most items are irreversible.
    def reverse; self end
  end
  
  # A mixin for temporal objects with a fixed duration of zero.
  module Instant
    def duration; 0 end
    def take(t) self end
    def drop(t) self end
  end
end
