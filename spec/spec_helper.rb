$:.unshift File.join(File.dirname(__FILE__), '../lib')

require 'rubygems'
require 'music'

include Music

def eg(*args, &block) it(*args, &block) end
