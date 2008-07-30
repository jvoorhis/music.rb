require 'rational'

module Kernel
  def alike?(*objs)
    if objs.empty? then true
    else
      k = objs.first.class
      objs.all? { |obj| k === obj }
    end
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
end

class Symbol
  def to_proc
    proc { |*args| args.shift.__send__(self, *args) }
  end
end

class Class
  def ctor; method(:new) end
end

module Math
  module_function
  def log2(x)
    Math.log(x) / Math.log(2)
  end
end  

class Numeric
  def clip_low(n)
    self > n ? self : n
  end
  alias clip_lo clip_low
  
  def clip_high(n)
    self < n ? self : n
  end
  alias clip_hi clip_high
  
  def clip(range)
    clip_low(range.begin).clip_high(range.end)
  end
end
