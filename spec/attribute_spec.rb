require File.join( File.dirname(__FILE__), 'spec_helper')

shared_examples_for "all attributes implementations" do
  it "can update its attributes" do
    o1 = @object.update_attribute(:arbitrary, 42)
    o1.class.should == @object.class
    o1.attributes[:arbitrary].should == 42
  end
  
  it "has attribute accessors" do
    o1 = @object.update_attribute(:arbitrary, 42)
    o1.arbitrary.should == 42
  end
  
  it "has attribute mutators" do
    o1 = @object.arbitrary(42)
    o1.arbitrary.should == 42
  end
  
  it "" do
    o1 = @object.arbitrary(21)
    o2 = o1.arbitrary { |a| a * 2 }
    o2.arbitrary.should == 42
  end
end

describe Silence do
  before(:all) do
    @object = Silence.new(1, :dynamic => :mf)
  end
  it_should_behave_like "all attributes implementations"
end

describe Note do
  before(:all) do
    @object = Note.new(60, 1, :dynamic => :mf)
  end
  it_should_behave_like "all attributes implementations"
end
