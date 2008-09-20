require File.join( File.dirname(__FILE__), 'spec_helper')

describe Key do
  before(:all) do
    @key = Key.new([c, d, e, f, g, a, b])
  end
  
  it "should determine whether a given Pitch is a member" do
    @key.include?(c4).should be_true
    @key.include?(cs4).should be_false
    @key.include?(d4).should be_true
    @key.include?(ds4).should be_false
    @key.include?(e4).should be_true
    @key.include?(f4).should be_true
    # ...
  end
  
  it "should transpose member pitches diatonically, by degrees of the scale" do
    @key.transpose(c4, -14).should == c2
    # ...
    @key.transpose(c4, -2).should == a3
    @key.transpose(c4, -1).should == b3
    @key.transpose(c4, 0).should == c4 # identity transposition
    @key.transpose(c4, 1).should == d4
    @key.transpose(c4, 2).should == e4
    @key.transpose(c4, 3).should == f4
    @key.transpose(c4, 4).should == g4
    @key.transpose(c4, 5).should == a4
    @key.transpose(c4, 6).should == b4
    @key.transpose(c4, 7).should == c5
    # ...
    @key.transpose(c4, 14).should == c6
  end
  
  it "should transpose non-member pitches diatonically" do
    @key.transpose(cf4, 1).should == df4
    @key.transpose(cf4, 2).should == ef4
    @key.transpose(cf4, 3).should == ff4
    
    @key.transpose(cs4, 1).should == ds4
    @key.transpose(cs4, 2).should == es4
    @key.transpose(cs4, 3).should == fs4
    
    @key.transpose(c4.flat.flat, 1).should == d4.flat.flat
    @key.transpose(c4.sharp.sharp, 1).should == d4.sharp.sharp
  end
end
