$:.unshift File.join(File.dirname(__FILE__), '../lib')

require 'rubygems'
require 'music'

include Music

module Spec::Example::ExampleGroupMethods
  alias eg it
end
