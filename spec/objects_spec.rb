require File.join( File.dirname(__FILE__), 'spec_helper')

describe Silence do
  before(:all) do
    @object = Silence.new(1, :dynamic => :mf)
  end
  
  it "should have a duration" do
    @object.duration.should == 1
  end
  
  it "can be constructed with attributes" do
    @object.attributes.should == { :dynamic => :mf }
  end
end

describe Note do
  before(:all) do
    @object = Note.new(60, 1, :dynamic => :mf)
  end
  
  it "should have a pitch" do
    @object.pitch.should == 60
  end
  
  it "should have a duration" do
    @object.duration.should == 1
  end
  
  it "can be constructed with attributes" do
    @object.attributes.should == { :dynamic => :mf }
  end
  
  it "can be transposed" do
    @object.transpose(2).should == Note.new(@object.pitch+2, @object.duration, @object.attributes)
  end
  
  it "can be compared" do
    [ Note.new(60,1,127),
      Note.new(60,1.0,127),
      Note.new(60,1.quo(1),127)
    ].each { |val| val.should == @object }
    [ Silence.new(1),
      Arrangement::Base.allocate
    ].each { |val| val.should_not == @object }
  end
end
