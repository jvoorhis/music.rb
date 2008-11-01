require File.join( File.dirname(__FILE__), 'spec_helper')

shared_examples_for "all scores" do
  it "can be composed sequentially" do
    seq = Seq.new(@object, rest(0))
    (@object & rest(0)).should  == seq
  end
  
  it "can be composed in parallel" do
    par = Par.new(@object, rest(0))
    (@object | rest(0)).should  == par
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
      (@object * 0).should == Score::Base.none
    end
    
    it "requires a non-negative Integer" do
      proc { @object * @object }.should raise_error(TypeError)
      proc { @object * 1.0 }.should raise_error(TypeError)
      proc { @object * -1 }.should raise_error(ArgumentError)
    end
  end
    
  it "can be delayed with a rest" do
    @object.delay(4).should == Seq.new(rest(4), @object)
  end
  
  describe "when reversed" do
    it "preserves its duration" do
      @object.reverse.duration.should == @object.duration
    end
    
    it "is equivalent when reversed twice" do
      @object.reverse.reverse.should === @object
    end
  end
end

describe Score::Base do
  it "should return the empty MusicObject" do
    Score::Base.none.should == Item.new( Rest.new(0) )
  end
end

describe Seq do
  before(:all) do
    @object = ((@left = note(60, 2)) & (@right = rest(3)))
  end
  
  it_should_behave_like "all scores"
  
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
    (@left & @right).should == @object
    (@right & @left).should_not == @object
  end
  
  it "can be transposed" do
    @object.transpose(5).should == @left.transpose(5) & @right.transpose(5)
  end
  
  it "can be mapped" do
    @object.map { |n| n.transpose(7) }.should ==
        @object.left.transpose(7) & @object.right.transpose(7)
  end
end

describe Par do
  before(:all) do
    @object = ((@top = note(60, 2)) | (@bottom = rest(3)))
  end
  
  it_should_behave_like "all scores"
  
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
    (@top | @bottom).should == @object
    (@bottom | @top).should_not == @object
  end
  
  it "can be transposed" do
    @object.transpose(5).should == @top.transpose(5) | @bottom.transpose(5)
  end
  
  it "can be mapped" do
    @object.map { |n| n.transpose(7) }.should ==
        @object.top.transpose(7) | @object.bottom.transpose(7)
  end
end

describe Section do
  before(:all) do
    @object = section(
    @music  =   note(60, 2) & note(60, 2, :accented => nil),
    @attrs  =   { :slur => true, :accented => true })
  end
  
  it_should_behave_like "all scores"
  
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
    Section.new(@music, @attrs).should == @object
  end
  
  it "can be compared independently of its attributes" do
    Section.new(@music).should == @object
  end
  
  it "can be transposed" do
    @object.transpose(5).should == Section.new(@music.transpose(5), @attrs)
  end
  
  it "should provide inherited attributes when interpreted" do
    timeline = TimelineInterpreter.eval(@object)
    timeline.all? { |e| e.attributes[:slur] }.should be_true
    
    timeline[0].object.attributes[:accented].should be_true
    timeline[1].object.attributes[:accented].should be_nil
  end
  
  it "can be mapped" do
    @object.map { |n| n.transpose(7) }.should ==
        section( @object.music.transpose(7), @object.attributes )
  end
end

describe Item do
  before(:all) do
    @object = note(60)
  end
  
  it "equals itself when reversed" do
    @object.reverse.should == @object
  end
  
  it "can be mapped" do
    @object.map { |n| n.transpose(7) }.should == note(67)
  end
end

shared_examples_for "all scores of reference duration" do
  it "will have a duration equal to the shortest tree under truncating parallel composition" do
    (@object / rest(@duration * 2)).duration.should == @duration
    (@object / rest(@duration / 2)).duration.should == @duration / 2
  end
end

describe "Seq of reference duration" do
  before(:all) do
    @duration = 4
    @object = (@left = rest(2) & @right = note(60, 2))
  end
  
  it_should_behave_like "all scores of reference duration"
end

describe "Par of reference duration" do
  before(:all) do
    @duration = 4
    @object = ((@left = note(64, 2) & note(64, 2)) | (@right = note(60, 4)))
  end
  
  it_should_behave_like "all scores of reference duration"
end

describe "Section of reference duration" do
  before(:all) do
    @duration = 4
    @object = section( note(64, 2) & note(64, 2) | note(60, 4), {} )
  end
  
  it_should_behave_like "all scores of reference duration"
end

describe "Item of reference duration" do
  before(:all) do
    @duration = 4
    @object = note(60, 4)
  end
  
  it_should_behave_like "all scores of reference duration"
end

describe "Rest of reference duration" do
  before(:all) do
    @duration = 4
    @object = rest(4)
  end
  
  it_should_behave_like "all scores of reference duration"
end

describe "helper functions" do
  it "should arrange notes" do
    note(60).should    == Item.new(Note.new(60, 1))
    note(60, 2).should == Item.new(Note.new(60, 2))
  end
  
  it "should arrange rests" do
    rest().should  == Item.new(Rest.new(1))
    rest(2).should == Item.new(Rest.new(2))
  end
  
  it "should arrange sections" do
    section(note(67) & note(60), {}).should == Section.new(note(67) & note(60), {})
  end
  
  it "should create the empty score" do
    none().should == rest(0)
  end
  
  it "should compose lists of scores sequentially" do
    seq(note(60), note(64), note(67)).should == note(60) & note(64) & note(67)
  end
  
  it "should compose lists of scores in parallel" do
    par(note(60), note(64), note(67)).should == note(60) | note(64) | note(67)
  end
end

