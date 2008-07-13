require File.join( File.dirname(__FILE__), 'spec_helper')

shared_examples_for "All MusicObjects" do
  it "can be composed sequentially" do
    seq = Seq.new(@object,Silence.new(0))
    ( @object & Silence.new(0) ).should  == seq
    @object.seq( Silence.new(0) ).should == seq
  end
  
  it "can be composed in parallel" do
    par = Par.new(@object, Silence.new(0))
    ( @object | Silence.new(0) ).should  == par
    @object.par( Silence.new(0) ).should == par
  end
  
  describe "repetition" do
    it "sequences an object with itself" do
      (@object * 2).should == (@object & @object) # sequential composition
      (@object * 3).should == (@object & @object & @object) # left-to-right
    end
    
    it "preserves left-to-right ordering" do
      (@object * 3).should == (@object & @object & @object)
    end
    
    it "is equal to itself under the identity" do
      (@object * 1).should == @object # Identity
    end
    
    it "requires an Integer" do
      proc { (@object * @object) }.should raise_error(TypeError)
      proc { (@object * 1.0) }.should raise_error(TypeError)
    end
  end
    
  it "can be delayed with silence" do
    @object.delay(4).should == Seq.new(Silence.new(4), @object)
  end
end

describe Silence do
  before(:all) do
    @object = Silence.new(1, :fermata => true)
  end
  
  it_should_behave_like "All MusicObjects"
  
  it "should have a duration" do
    @object.duration.should == 1
  end
  
  it "should have attributes" do
    @object.attributes.should == { :fermata => true }
  end
end

describe Note do
  before(:all) do
    @object = Note.new(60, 1, 127, :fermata => true)
  end
  
  it_should_behave_like "All MusicObjects"
  
  it "should have a pitch" do
    @object.pitch.should == 60
  end
  
  it "should have a duration" do
    @object.duration.should == 1
  end
  
  it "should have effort" do
    @object.effort.should == 127
  end
  
  it "should have attributes" do
    @object.attributes.should == { :fermata => true }
  end
  
  it "can be transposed" do
    @object.transpose(2).should == Note.new(62, 1, 127)
  end
  
  it "can be compared" do
    [ Note.new(60,1,127),
      Note.new(60,1.0,127),
      Note.new(60,1.quo(1),127)
    ].each { |val| val.should == @object }
    [ Silence.new(1),
      MusicObject.allocate
    ].each { |val| val.should_not == @object }
  end
end

describe Seq do
  before(:all) do
    @object = Seq.new( 
    @left   =   Note.new(60,2,127), 
    @right  =   Silence.new(3))
  end
  
  it_should_behave_like "All MusicObjects"
  
  it "has a left value" do
    @object.left.should == @left
  end
  
  it "has a right value" do
    @object.right.should == @right
  end
  
  it "has a duration" do
    @object.duration.should == ( @left.duration + @right.duration )
  end
  
  it "can be compared" do
    @left.seq(@right).should == @object
    @right.seq(@left).should_not == @object
  end
  
  it "can be cast to an Array" do
    notes = [60, 64, 67].map { |pit| Note.new(pit, 1, 100) }
    notes.inject { |a,b| a & b }.to_a.should == notes
  end
end

describe Par do
  before(:all) do
    @object = Par.new(
    @top    =   Note.new(60,2,127),
    @bottom =   Silence.new(3))
  end
  
  it_should_behave_like "All MusicObjects"
  
  it "has a top value" do
    @object.top.should == @top
  end
  
  it "has a bottom value" do
    @object.bottom.should == @bottom
  end
  
  it "has a duration" do
    @object.duration.should == [@top.duration, @bottom.duration].max
  end
  
  it "can be compared" do
    @top.par(@bottom).should == @object
    @bottom.par(@top).should_not == @object
  end
end

describe Group do
  before(:all) do
    @object = Group.new(
    @music  =   Note.new(60, 2, 100).seq(Note.new(60, 2, 100)),
    @attrs  =   { :slur => true })
  end
  
  it_should_behave_like "All MusicObjects"
  
  it "wraps a MusicObject" do
    @object.music.should == @music
  end
  
  it "has a duration" do
    @object.duration.should == @music.duration
  end
  
  it "has attributes" do
    @object.attributes.should == @attrs
  end
  
  it "can be compared" do
    Group.new(@music, @attrs).should == @object
  end
  
  it "can be compared independently of its attributes" do
    Group.new(@music).should == @object
  end
end
