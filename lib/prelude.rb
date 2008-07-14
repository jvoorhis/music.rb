module Kernel
  def alike?(*objs)
    if objs.empty? then true
    else
      k = objs.first.class
      objs.all? { |obj| k === obj }
    end
  end
end

class Array
  def sum
    inject(0) { |a, b| a + b }
  end
end

class Symbol
  def to_proc
    proc { |obj, *args| obj.send(self, *args) }
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
