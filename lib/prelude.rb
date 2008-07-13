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
