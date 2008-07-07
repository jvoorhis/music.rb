require File.join( File.dirname(__FILE__), 'spec_helper')

describe MusicEvent do
  
  describe Silence do
    before(:each) do
      @event = Silence.new(1)
    end
    
    it "should have a duration" do
      @event.duration.should == 1
    end
    
    it "can be performed" do
      @event.should be_performed_with(:play_silence)
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
    
    it "can be performed" do
      @event.should be_performed_with(:play_note)
    end
    
    it "can be transposed" do
      @event.transpose(2).should == Note.new(62, 1, 127)
    end
  end
  
  describe Chord do
    before(:each) do
      @event = Chord.new([60, 64, 67], 1, 127)
    end
    
    it "should have a list of pitches" do
      @event.pitches.should == [60, 64, 67]
    end
    
    it "should have a duration" do
      @event.duration.should == 1
    end
    
    it "should have effort" do
      @event.effort.should == 127
    end
    
    it "can enumerate its pitches with their respective efforts" do
      data = []
      @event.pitch_with_effort { |p, i| data << [p,i] }
      data.should == [[60, 127], [64, 127], [67, 127]]
    end
    
    it "can have efforts specific to its pitches" do
      chord = Chord.new([60, 64, 67], 1, [100, 110, 127])
      data = []
      chord.pitch_with_effort { |p, i| data << [p,i] }
      data.should == [[60, 100], [64, 110], [67, 127]]
    end
    
    it "can be performed" do
      @event.should be_performed_with(:play_chord)
    end
    
    it "can be transposed" do
      @event.transpose(2).should == Chord.new([62, 66, 69], 1, 127)
    end
  end
end
