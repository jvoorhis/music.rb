require File.join( File.dirname(__FILE__), 'spec_helper')
require 'rational'
require 'music/midi_time'

include Music

describe Music, "midi interface" do
  
  describe MidiTime do
    it "should convert qn to ppqn" do
      t = MidiTime.new(480)
      { 1        => 480,
        1.0      => 480,
        2        => 960,
        2.0      => 960,
        2.quo(1) => 960,
        0.5      => 240,
        1.quo(2) => 240,
        1.quo(3) => 160,
        1.quo(7) => 69
      }.each do |dur,ppqn|
        x = t.ppqn(dur)
        x.should be_kind_of(Integer)
        x.should == ppqn
      end
      
      proc { t.ppqn(".5") }.should raise_error(ArgumentError)
    end
  end
end
