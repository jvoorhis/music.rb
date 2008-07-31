require File.join( File.dirname(__FILE__), 'spec_helper')

shared_examples_for "all arrangements" do
  it "can be composed sequentially" do
    seq = Seq.new(@object, silence(0))
    ( @object & silence(0) ).should  == seq
    @object.seq( silence(0) ).should == seq
  end
  
  it "can be composed in parallel" do
    par = Par.new(@object, silence(0))
    ( @object | silence(0) ).should  == par
    @object.par( silence(0) ).should == par
  end
  
  it "preserves its structure when mapped with the identity function" do
    @object.map(&ID).should == @object
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
      (@object * 0).should == Arrangement::Base.none
    end
    
    it "requires a non-negative Integer" do
      proc { @object * @object }.should raise_error(TypeError)
      proc { @object * 1.0 }.should raise_error(TypeError)
      proc { @object * -1 }.should raise_error(ArgumentError)
    end
  end
    
  it "can be delayed with silence" do
    @object.delay(4).should == Seq.new(silence(4), @object)
  end
  
  describe "when reversed" do
    it "preserves its duration" do
      @object.reverse.duration.should == @object.duration
    end
    
    it "is equivalent when reversed twice" do
      Performer.perform(@object.reverse.reverse).should == Performer.perform(@object)
    end
  end
end

describe Arrangement::Base do
  it "should return the empty MusicObject" do
    Arrangement::Base.none.should == Item.new( Silence.new(0) )
  end
end

describe Seq do
  before(:all) do
    @object = ((@left = note(60,2,127)) & (@right = silence(3)))
  end
  
  it_should_behave_like "all arrangements"
  
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
  
  it "maps its contents, but retains its structure" do
    @object.map { |n| n.transpose(7) }.should ==
        @object.left.transpose(7) & @object.right.transpose(7)
  end
end

describe Par do
  before(:all) do
    @object = ((@top = note(60,2,127)) | (@bottom = silence(3)))
  end
  
  it_should_behave_like "all arrangements"
  
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
  
  it "maps its contents, but retains its structure" do
    @object.map { |n| n.transpose(7) }.should ==
        @object.top.transpose(7) | @object.bottom.transpose(7)
  end
end

describe Group do
  before(:all) do
    @object = group(
    @music  =   note(60, 2, 100) & note(60, 2, 100, :accented => nil),
    @attrs  =   { :slur => true, :accented => true })
  end
  
  it_should_behave_like "all arrangements"
  
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
  
  it "should provide inherited attributes when interpreted" do
    timeline = Performer.perform(@object)
    timeline.events.all? { |e| e.object.attributes[:slur] }.should be_true
    
    timeline[0].object.attributes[:accented].should be_true
    timeline[1].object.attributes[:accented].should be_nil
  end
  
  it "maps its contents, but retains its structure" do
    @object.map { |n| n.transpose(7) }.should ==
        group( @object.music.transpose(7), @object.attributes )
  end
end

describe Item do
  before(:all) do
    @object = note(60)
  end
  
  it "equals itself when reversed" do
    @object.reverse.should == @object
  end
  
  it "maps its contents, but retains its structure" do
    @object.map { |n| n.transpose(7) }.should == note(67)
  end
end

# Choose an arbitrary reference duration for atomic
# and aggregate MusicObjectsm for unit testing.
RD = 4      # reference duration
MD = RD / 2 # midpoint
shared_examples_for "all arrangements of reference duration" do
  
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
    @object = (@left = silence(RD/2) & @right = note(60, RD/2, 100))
  end
  
  it_should_behave_like "all arrangements of reference duration"
end

describe "Par of reference duration" do
  before(:all) do
    hn = RD/4
    @object = ((@left = note(64, hn, 100) & note(64, hn, 100)) | (@right = note(60, RD, 100)))
  end
  
  it_should_behave_like "all arrangements of reference duration"
end

describe "Group of reference duration" do
  before(:all) do
    hn = RD/4
    @object = group( note(64, hn, 100) & note(64, hn, 100) | note(60, RD, 100), {} )
  end
  
  it_should_behave_like "all arrangements of reference duration"
end

describe "Item of reference duration" do
  before(:all) do
    @object = note(60, RD, 100)
  end
  
  it_should_behave_like "all arrangements of reference duration"
end

describe "Silence of reference duration" do
  before(:all) do
    @object = silence(RD)
  end
  
  it_should_behave_like "all arrangements of reference duration"
end

describe "helper functions" do
  it "should arrange notes" do
    note(60).should      == Item.new( Note.new(60,1,100) )
    note(60,2).should    == Item.new( Note.new(60,2,100) )
    note(60,3,80).should == Item.new( Note.new(60,3,80) )
  end
  
  it "should arrange silence" do
    rest().should  == Item.new( Silence.new(1) )
    rest(2).should == Item.new( Silence.new(2) )
  end
  
  it "should arrange groups" do
    group(note(67) & note(60), {}).should == Group.new(note(67) & note(60), {})
  end
  
  it "should create the empty arrangement" do
    none().should == silence(0)
  end
  
  it "should compose lists of arrangements sequentially" do
    line(note(60), note(64), note(67)).should == note(60) & note(64) & note(67)
  end
  
  it "should compose lists of arrangements in parallel" do
    chord(note(60), note(64), note(67)).should == note(60) | note(64) | note(67)
  end
end
  
