require 'forwardable'
require 'random'

class Class
  def ctor; method(:new) end
end

class Method
  def liftM(*ms) Kernel.liftM(*ms, &self) end
end

class Proc
  def liftM(*ms) Kernel.liftM(*ms, &self) end
end

module Kernel
  def alike?(*objs)
    if objs.empty? then true
    else
      k = objs.first.class
      objs.all? { |obj| k === obj }
    end
  end
  
  def liftM(*ms, &block)
    raise ArgumentError, "Given #{ms.size} args, and block of #{block.arity} args." if ms.size != block.arity && block.arity != -1
    case ms.size
    when 1: liftM1(*ms, &block)
    when 2: liftM2(*ms, &block)
    when 3: liftM3(*ms, &block)
    else raise ArgumentError, "Cannot lift block of #{block.arity} args."
    end
  end
  
  def liftM1(m1)
    m1.in { |v1| m1.class.ret yield(v1) }
  end
  
  def liftM2(m1, m2)
    raise TypeError if not alike?(m1, m2)
    m1.in do |v1|
      m2.in do |v2|
        m1.class.ret yield(v1, v2)
      end
    end
  end
  
  def liftM3(m1, m2, m3)
    raise TypeError if not alike?(m1, m2, m3)
    m1.in do |v1|
      m2.in do |v2|
        m3.in do |v3|
          m1.class.ret yield(v1, v2, v3)
        end
      end
    end
  end
end

class Gen
  extend Forwardable
  
  def self.rand; new { |n, r| r } end
  
  def self.sized(&fgen)
    new do |n, r|
      m = fgen[n]
      m[ n, r ]
    end
  end
  
  def initialize(&fn) @fn = fn end
  def_delegators :@fn, :call, :[]
  
  ## Functor operations
  def fmap(&f)
    bind { |v| ret f[v] }
  end
  alias :with :fmap
  
  ## Monadic operations
  def self.ret(a)
    new { |n, rng| a }
  end
  def ret(a) self.class.ret(a) end
  
  def bind(&k)
    self.class.new do |n, r0|
      r1, r2 = r0.split
      m1     = k[ self[ n, r1 ] ]
      m1[ n, r2 ]
    end
  end
  alias :in :bind
  
  def generate(n, rnd)
    sz, rnd1 = Integer.randomr(0..n, rnd)
    self[ sz, rnd1 ]
  end
  
  def run(n, rnd = StdGen.seed)
    case val = generate(n, rnd)
    when Gen: val.run(n, rnd)
    else val
    end
  end
  
  def self.choose(range)
    array = range.to_a
    Gen.rand.
      fmap { |rng| Integer.randomr((0 .. array.size-1), rng).first }.
      fmap { |i| array[i] }
  end
  
  def self.elements(gens)
    ( 0 .. (gens.size-1) ).choose.fmap { |i| gens[i] }
  end
  
  def self.one_of(gens)
    elements(gens).bind { |g| g }
  end
end

class Object
  def to_gen; Gen.ret self end
end

class Array
  def elements; Gen.elements(self) end
  def one_of; Gen.one_of(self) end
end

class Range
  def choose; Gen.choose(self) end
end

class Integer
  def self.arbitrary
    Gen.sized { |n| (-n..n).choose }
  end
end

class NilClass
  def self.arbitrary; nil.to_gen end
  def arbitrary; self.class.arbitrary end
end

class TrueClass
  def self.arbitrary; [true, false].elements end
end

class FalseClass
  def self.arbitrary; [true, false].elements end
end
