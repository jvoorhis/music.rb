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
