require File.join( File.dirname(__FILE__), 'spec_helper')

shared_examples_for "all structures" do
  it "can have a next structure" do
    ns = Constant.new Silence.new(1)
    (@structure >> ns).should == ns
    @structure.has_next?.should be_true
    @structure.next_structure.should == ns
  end
  
  it "can generate a Surface" do
    proc {
      @structure.surface.should be_kind_of(Surface)
    }.should_not raise_error
  end
end

describe Constant do
  before(:each) do
    @structure = Constant.new Silence.new(1)
  end
  
  it_should_behave_like "all structures"
  
  it "should generate a copy of its prototype event" do
    surface = @structure.surface
    surface.should have(1).event
    surface.first.should == Silence.new(1)
  end
  
  it "should activate the next event" do
    next_structure = Constant.new(Silence.new(1))
    @structure >> next_structure
    next_structure.should_receive(:activate)
    @structure.next
  end
end

describe Interval do
  before(:each) do
    @structure = Interval.new(2)
  end
  
  it_should_behave_like "all structures"
  
  it "should trasnpose notes by the number of halfsteps it instantiated with" do
    hd = Constant.new Note.new(60, 1, 127)
    hd >> @structure
    hd.should generate(Note.new(60, 1, 127), Note.new(62, 1, 127))
  end
  
  it "can tranpose the pitch of a note, but apply a new duration and effort" do
    hd = Constant.new Note.new(60, 1, 127)
    hd >> Interval.new(2, 2, 100)
    hd.should generate(Note.new(60, 1, 127), Note.new(62, 2, 100))
  end
  
  it "should transpose chords by the number of halfsteps it was instantiated with" do
    hd = Constant.new Chord.new([60, 67], 1, 127)
    hd >> @structure
    hd.should generate(Chord.new([60, 67], 1, 127), Chord.new([62, 69], 1, 127))
  end
  
  it "should generate Silence with no duration if a suitable Chord or Note cannot be found" do
    hd = Interval.new(2)
    hd.surface.to_a.should == [Silence.new(0)]
  end
end

describe Repeat do
  before(:each) do
    @hd = Constant.new(Note.new(60, 1, 127))
    @structure = Repeat.new(3, @hd)
    @next = Constant.new(Silence.new(1))
    @hd >> @structure >> @next
  end
  
  it_should_behave_like "all structures"
  
  it "should activate the given structure N times before proceeding" do
    @hd.should generate(
      Note.new(60, 1, 127), Note.new(60, 1, 127), Note.new(60, 1, 127),
      Note.new(60, 1, 127), Silence.new(1)
    )
  end
  
  describe "when the structure has no next element" do
    before(:each) do
      @hd = Constant.new(Note.new(60, 1, 127))
      @structure = Repeat.new(3, @hd)
      @next = Constant.new(Silence.new(1))
      @structure >> @next
    end
    
    it "should should be activated by its target" do
      @structure.should generate(
        Note.new(60, 1, 127), Note.new(60, 1, 127),
        Note.new(60, 1, 127), Silence.new(1)
      )
    end
  end
  
  describe "when the structure has no return path" do
    before(:each) do
      (@phrase=Constant.new(Note.new(60, 1, 127))) >> 
        Constant.new(Note.new(62, 1, 127)) >> 
        Constant.new(Note.new(64, 1, 127))
      @structure = Repeat.new(2, @phrase)
    end
    
    it "should be activated after the completion of its target phrase" do
      @structure.should generate(
        Note.new(60, 1, 127), Note.new(62, 1, 127),
        Note.new(64, 1, 127), Note.new(60, 1, 127),
        Note.new(62, 1, 127), Note.new(64, 1, 127)
      )
    end
  end
end

describe Choice do
  before(:each) do
    @__original_rng = Music.rng
    @rng = Music.rng = StubRNG.new
    
    @structure = Choice.new(
      Constant.new(Note.new(60, 1, 127)),
      Constant.new(Note.new(64, 1, 127))
    )
  end
  after(:all) { Music.rng = @__original_rng }
  
  it_should_behave_like "all structures"
  
  it "should randomly choose the next structure from its choices" do
    @structure.should generate(Note.new(60, 1, 127))
    @rng.val = 0.5
    @structure.should generate(Note.new(64, 1, 127))
  end
  
  it "should splice its next event after selecting a lone event from its choices" do
    @structure >> Constant.new(Silence.new(1))
    @structure.should generate(Note.new(60, 1, 127), Silence.new(1))
  end
end

describe Cycle do
  before(:each) do
    @structure = Cycle.new(
      Constant.new(Note.new(60, 1, 127)),
      Constant.new(Silence.new(1))
    )
  end
  
  it_should_behave_like "all structures"
  
  it "should cycle through its choices"
end

describe Fun do
  before(:each) do
    @structure = Fun.new { |s| Note.new(60, 1, 127) }
  end
  
  it_should_behave_like "all structures"
  
  it "should generate the value of its block" do
    @structure.should generate(Note.new(60, 1, 127))
  end
end
