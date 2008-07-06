$:.unshift File.join(File.dirname(__FILE__), '../lib')

require 'rubygems'
require 'music'

include Music

# Blithely deterministic RNG for testing.
class StubRNG
  attr_accessor :val
  alias :rand :val
  def initialize(val=0.0) @val = val end
end

def given_random_number(val)
  prior_rng = Music.rng
  Music.rng = StubRNG.new(val)
  yield
ensure
  Music.rng = prior_rng
end

class SurfaceMatcher
  def initialize(events)
    @events = events
  end
  
  def matches?(structure)
    @surface = structure.surface
    @surface.to_a == @events
  end
  
  def failure_message
    "Should have generated\n\t%s\nGot\n\t%s" % [
      @events.map { |e| e.class.name } * ', ',
      @surface.map { |e| e.class.name } * ', '
    ]
  end
end

def generate(*events)
  SurfaceMatcher.new(events)
end

class VisitorMatcher
  class StubVisitor
    def initialize(meth_sym)
      @match = false
      eval "def #{meth_sym}(*args) @match = true end"
    end
    
    def method_missing(meth_sym, *args)
      @match = false
      @__meth_sym = meth_sym
    end
    
    def __meth_sym; @__meth_sym.nil? ? "nothing" : @__meth_sym end
    
    def __matches?; @match == true end
  end
  
  def initialize(meth_sym)
    @visitor = StubVisitor.new(meth_sym)
    @meth_sym = meth_sym
  end
  
  def matches?(ev)
    ev.perform(@visitor)
    @visitor.__matches?
  end
  
  def failure_message
    "Expected visit with #@meth_sym. Got #{@visitor.__meth_sym}."
  end
end

def be_performed_with(meth_sym)
  VisitorMatcher.new(meth_sym)
end
