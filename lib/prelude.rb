require 'rational'

ID = lambda { |x| x }

module Kernel
  def silence_warnings
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end
end

class Object
  def returning(s,&k) k[s]; s end
end

module Enumerable
  def map_with_index
    inject([0, []]) { |(i, xs), x| [i + 1, xs + [yield(x, i)]] }[-1]
  end
end

class Array
  def sum
    inject(0) { |a, b| a + b }
  end
  
  def one?; size == 1 end
  
  def many?; size > 1 end
end

class Symbol
  def to_proc
    proc { |*args| args.shift.__send__(self, *args) }
  end
end

module Math
  LOG2 = Math.log(2)
  
  module_function
  def log2(x)
    Math.log(x) / LOG2
  end
end  

class Numeric
  
  def sgn
    if zero? then 0
    elsif self > 0 then 1
    else -1 end
  end
  
  def clip_low(n)
    self > n ? self : n
  end
  alias clip_lo clip_low
  
  def clip_high(n)
    self < n ? self : n
  end
  alias clip_hi clip_high
  
  def clip(range)
    clip_low(range.first).clip_high(range.last)
  end
end
