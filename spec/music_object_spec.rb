require File.join( File.dirname(__FILE__), 'spec_helper')

describe MusicObject do
  
  shared_examples_for "All MusicObjects" do
    # TODO ...
  end
  
  describe Silence do
    before(:each) do
      @event = Silence.new(1)
    end
    
    it "should have a duration" do
      @event.duration.should == 1
    end
  end
  
  describe Note do
    before(:each) do
      @event = Note.new(60, 1, 127)
    end
    
    it "should have a pitch" do
      @event.pitch.should == 60
    end
    
    it "should have a duration" do
      @event.duration.should == 1
    end
    
    it "should have effort" do
      @event.effort.should == 127
    end
    
    it "can be transposed" do
      @event.transpose(2).should == Note.new(62, 1, 127)
    end
  end
  
  describe Seq do
    # TODO ...
  end
  
  describe Par do
    # TODO ...
  end
end
