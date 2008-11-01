require File.join( File.dirname(__FILE__), 'spec_helper')

# Choose an arbitrary reference duration for atomic
# and aggregate MusicObjectsm for unit testing.
RD = 4      # reference duration
MD = RD / 2 # midpoint
shared_examples_for "all temporal objects" do
  
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
end

describe Seq do
  before(:all) do
    @object = (@left = rest(RD/2) & @right = note(60, RD/2))
  end
  it_should_behave_like "all temporal objects"
end

describe Par do
  before(:all) do
    hn = RD/4
    @object = ((@left = note(64, hn) & note(64, hn)) | (@right = note(60, RD)))
  end
  it_should_behave_like "all temporal objects"
end

describe Section do
  before(:all) do
    hn = RD/4
    @object = section( note(64, hn) & note(64, hn) | note(60, RD), {} )
  end
  it_should_behave_like "all temporal objects"
end

describe Note do
  before(:all) do
    @object = note(60, RD)
  end
  it_should_behave_like "all temporal objects"
end

describe Rest do
  before(:all) do
    @object = rest(RD)
  end
  it_should_behave_like "all temporal objects"
end

