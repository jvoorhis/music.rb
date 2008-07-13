require File.join( File.dirname(__FILE__), 'spec_helper')
require 'functor'

include Music

ID = proc { |x| x }

shared_examples_for "All Functors" do
  it "preserves its structure under id" do
    @object.fmap(&ID).should == @object
  end
end

describe Seq do
  before(:all) do
    @object = Seq.new(
    @left   =   Note.new(65, 2, 100),
    @right  =   Note.new(64, 2, 100))
  end
  
  it_should_behave_like "All Functors"
  
  it "maps its atoms, but retains its structure" do
    @object.fmap { |n| n.transpose(7) }.should ==
      Seq.new( Note.new(72, 2, 100), Note.new(71, 2, 100) )
  end
end

describe Par do
  before(:all) do
    @object = Par.new(
    @left   =   Note.new(65, 2, 100),
    @right  =   Note.new(64, 2, 100))
  end
  
  it_should_behave_like "All Functors"
  
  it "maps its atoms, but retains its structure" do
    @object.fmap { |n| n.transpose(7) }.should ==
      Par.new( Note.new(72, 2, 100), Note.new(71, 2, 100) )
  end
end

describe Group do
  before(:all) do
    @object = Group.new(
    @music  =   Note.new(65, 2, 100).seq(Note.new(64, 2, 100)))
  end
  
  it_should_behave_like "All Functors"
  
  it "maps its atoms, but retains its structure" do
    @object.fmap { |n| n.transpose(7) }.should ==
      Group.new( Note.new(72, 2, 100).seq(Note.new(71, 2, 100)) )
  end
end

describe Note do
  before(:all) do
    @object = Note.new(60, 4, 100)
  end
  
  it_should_behave_like "All Functors"
  
  it "maps itself" do
    @object.fmap { |n| n.transpose(7) }.should == @object.transpose(7)
  end
end

describe Silence do
  before(:all) do
    @object = Silence.new(4)
  end
  
  it_should_behave_like "All Functors"
  
  it "maps itself" do
    @object.fmap { |n| Silence.new(1) }.should == Silence.new(1)
  end
end
