require File.join( File.dirname(__FILE__), 'spec_helper')

describe Scale do
  before(:all) do
    @degrees = [0, 2, 4, 5, 7, 9, 11]
    @scale   = Scale.new(@degrees)
  end
  
  it "should determine membership of pitches in arbitrary octaves" do
    memberships = {
      0  => true, 1  => false,
      2  => true, 3  => false,
      4  => true,
      5  => true, 6  => false,
      7  => true, 8  => false,
      9  => true, 10 => false,
      11 => true
    }
    
    (1..12).each do |octave|
      memberships.each do |pc, is_member|
        pitch = pc + (octave * 12)
        @scale.member?(pitch).should == is_member
      end
    end
  end
  
  it "should transpose member pitches by the given number of degrees" do
    root = 60
    @degrees.sort.uniq.each_with_index do |hs, deg|
      @scale.transpose(root, deg).should == root + hs
    end
  end
  
  it "should transpose non-member pitches" do
    @scale.transpose(61, 1).should == 63
    @scale.transpose(61, 2).should == 65
    @scale.transpose(61, 3).should == 66
    @scale.transpose(61, 4).should == 68
    @scale.transpose(61, 5).should == 70
    @scale.transpose(61, 6).should == 72
  end
end
