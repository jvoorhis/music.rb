class Symbol
  def to_proc
    proc { |obj, *args| obj.send(self, *args) }
  end
end

class Class
  def ctor; method(:new) end
end
