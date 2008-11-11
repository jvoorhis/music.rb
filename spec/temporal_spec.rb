require File.join( File.dirname(__FILE__), 'spec_helper')

# Choose an arbitrary reference duration for atomic
# and aggregate MusicObjectsm for unit testing.
shared_examples_for "all temporal objects" do
  
  describe "can be taken from" do
    it "by a shorter duration" do
      @object.take(@dur/2).duration.should == @dur/2
    end
    
    it "by zero" do
      @object.take(0).duration.should be_zero
    end
    
    it "by a longer duration" do
      @object.take(@dur*2).duration.should == @dur
    end
    
    it "by a negative duration" do
      @object.take(-1).duration.should be_zero
    end
  end
  
  describe "can be dropped from" do
    it "by a shorter duration" do
      @object.drop(@dur/2).duration.should == @dur/2
    end
    
    it "by zero" do
      @object.drop(0).duration.should == @dur
    end
    
    it "by a longer duration" do
      @object.drop(@dur*2).duration.should be_zero
    end
    
    it "by a negative duration" do
      @object.drop(-1).duration.should == @dur
    end
  end
  
  describe "can be sliced" do
    it "by range" do
      @object.slice(0..@dur/2).duration.should == @dur/2
    end
    
    it "by endpoint" do
      @object.slice(@dur/2).duration.should == @dur/2
    end
    
    it "with negative endpoint" do
      qn = @dur/4
      @object.slice(qn..-qn).duration.should == @dur/2
    end
    
    it "with negative start and endpoints" do
      qn    = @dur/4
      range = -(qn*2)-1..-qn
      @object.slice(range).duration.should == @dur/2
    end
  end
end

describe Seq do
  before(:all) do
    @dur = 4
    @object = (rest(@dur/2) & note(c4, @dur/2))
  end
  it_should_behave_like "all temporal objects"
end

describe Par do
  before(:all) do
    @dur = 4
    hn = @dur/4
    @object = (sn([e4, e4], hn) | note(c4, @dur))
  end
  it_should_behave_like "all temporal objects"
end

describe Group do
  before(:all) do
    @dur = 4
    hn = @dur/4
    @object = group( sn([e4, e4], hn) | note(c4, @dur), {} )
  end
  it_should_behave_like "all temporal objects"
end

describe Note do
  before(:all) do
    @dur = 4
    @object = note(c4, @dur)
  end
  it_should_behave_like "all temporal objects"
end

describe Rest do
  before(:all) do
    @dur = 4
    @object = rest(@dur)
  end
  it_should_behave_like "all temporal objects"
end

describe Controller do
  before(:all) do
    @dur = 0
    @object = ctl(:tempo, 120)
  end
  it_should_behave_like "all temporal objects"
end
