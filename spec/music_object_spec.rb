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
  
  describe "when repeated" do
    it "sequences an object with itself" do
      (@object * 2).should == (@object & @object) # sequential composition
      (@object * 3).should == (@object & @object & @object) # left-to-right
    end
    
    it "preserves left-to-right ordering" do
      (@object * 3).should == (@object & @object & @object)
    end
    
    it "is equal to itself under the identity" do
      (@object * 1).should == @object
    end
    
    it "returns the unit when given 0" do
      (@object * 0).should == MusicObject.none
    end
    
    it "requires a non-negative Integer" do
      proc { @object * @object }.should raise_error(TypeError)
      proc { @object * 1.0 }.should raise_error(TypeError)
      proc { @object * -1 }.should raise_error(ArgumentError)
    end
  end
    
  it "can be delayed with silence" do
    @object.delay(4).should == Seq.new(Silence.new(4), @object)
  end
  
  describe "when reversed" do
    it "preserevs its duration" do
      @object.reverse.duration.should == @object.duration
    end
    
    it "is equivalent when reversed twice" do
      Performer.new.perform(@object.reverse.reverse).should == Performer.new.perform(@object)
    end
  end
end

describe MusicObject do
  it "should return the empty MusicObject" do
    MusicObject.none.should == Silence.new(0)
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
  
  it "can be transposed" do
    @object.transpose(5).should == @left.transpose(5) & @right.transpose(5)
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
    @object.top.should === @top
  end
  
  it "has a bottom value" do
    @object.bottom.should === @bottom
  end
  
  it "has a duration" do
    @object.duration.should == [@top.duration, @bottom.duration].max
  end
  
  it "can be compared" do
    @top.par(@bottom).should == @object
    @bottom.par(@top).should_not == @object
  end
  
  it "can be transposed" do
    @object.transpose(5).should == @top.transpose(5) | @bottom.transpose(5)
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
  
  it "can be transposed" do
    @object.transpose(5).should == Group.new(@music.transpose(5), @attrs)
  end
end

# Choose an arbitrary reference duration for atomic
# and aggregate MusicObjectsm for unit testing.
RD = 4      # reference duration
MD = RD / 2 # midpoint
shared_examples_for "All MusicObjects of reference duration" do
  
  describe "can be taken from" do
    it "by a shorter duration" do
      @object.take(MD).duration.should == MD
    end
    
    it "by zero" do
      @object.take(0).duration.should be_zero
    end
    
    it "by a longer duration" do
      @object.take(RD*2).duration.should == RD
    end
    
    it "by a negative duration" do
      @object.take(-1).duration.should be_zero
    end
  end
  
  describe "can be dropped from" do
    it "by a shorter duration" do
      @object.drop(MD).duration.should == MD
    end
    
    it "by zero" do
      @object.drop(0).duration.should == RD
    end
    
    it "by a longer duration" do
      @object.drop(RD*2).duration.should be_zero
    end
    
    it "by a negative duration" do
      @object.drop(-1).duration.should == RD
    end
  end
  
  describe "can be sliced" do
    it "by range" do
      @object.slice(0..MD).duration.should == MD
    end
    
    it "by endpoint" do
      @object.slice(MD).duration.should == MD
    end
    
    it "with negative endpoint" do
      qn = RD/4
      @object.slice(qn..-qn).duration.should == MD
    end
    
    it "with negative start and endpoints" do
      qn    = RD/4
      range = -(qn*2)-1..-qn
       (-3..-1).should == range # example
      @object.slice(range).duration.should == MD
    end
  end
  
  describe "in truncating parallel composition" do
    it "will have a duration equal to the shortest tree" do
      (@object / rest(RD*2)).duration.should == RD
      (@object / rest(RD/2)).duration.should == RD/2
    end
  end
end

describe "Seq of reference duration" do
  before(:all) do
    @object = Seq.new(
    @left   =   Silence.new(RD/2),
    @right  =   Note.new(60, RD/2, 100))
  end
  
  it_should_behave_like "All MusicObjects of reference duration"
end

describe "Par of reference duration" do
  before(:all) do
    hn = RD/4
    @object = Par.new(
    @left   =   Note.new(64, hn, 100).seq(Note.new(64, hn, 100)),
    @right  =   Note.new(60, RD, 100))
  end
  
  it_should_behave_like "All MusicObjects of reference duration"
end

describe "Group of reference duration" do
  before(:all) do
    hn = RD/4
    @object = Group.new(
                Note.new(64, hn, 100).seq(
                  Note.new(64, hn, 100)).par(
                  Note.new(60, RD, 100)), {})
  end
  
  it_should_behave_like "All MusicObjects of reference duration"
end

describe "Note of reference duration" do
  before(:all) do
    @object = Note.new(60, RD, 100)
  end
  
  it_should_behave_like "All MusicObjects of reference duration"
end

describe "Silence of reference duration" do
  before(:all) do
    @object = Silence.new(RD)
  end
  
  it_should_behave_like "All MusicObjects of reference duration"
end
