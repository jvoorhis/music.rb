require File.join( File.dirname(__FILE__), 'spec_helper')
require 'rational'

describe Music do
  
  describe "functions of pitch" do
    it "mtof should convert midi pitch numbers to Hz" do
      { 60  => 261,
        69  => 440,
        0   => 8,
        127 => 12543 }.each do |m, hz|
        Music.mtof(m).floor.should == hz
      end
    end
    
    it "mtof should be the inverse of ftom" do
      (0..127).each do |m|
        Music.ftom(Music.mtof(m)).should == m
      end
    end
    
    it "should convert any Integer or Float to Hz" do
      { 69    => 440.0,
        440.0 => 440.0 }.each do |arg, hz|
        Music.Hertz(arg).should == hz
      end
      
      proc { Music.Hertz(1.quo(1)) }.should raise_error(ArgumentError)
    end
  end
end
