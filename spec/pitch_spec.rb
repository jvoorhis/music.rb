require File.join( File.dirname(__FILE__), 'spec_helper')

describe Pitch do
  it "can be created from an integer" do
    Pitch.from_integer(0).should   == c_1
    Pitch.from_integer(69).should  == a4
    Pitch.from_integer(127).should == g9
  end
end

describe PitchClass do
  it "has a rank" do
    { c => 0,
      d => 2,
      e => 4,
      f => 5,
      g => 7,
      a => 9,
      b => 11 }.all? { |pc, i| pc.rank == i }.should be_true
  end
  
  it "has a natural rank" do
    [c,d,e,f,g,a,b].all? { |pc| pc.natural_rank == pc.rank }.should be_true
  end
  
  it "can be cast to an Integer" do
    [c,d,e,f,g,a,b].all? { |pc| pc.to_i == pc.rank }.should be_true
  end
  
  it "can be constructed from an Integer" do
    { 0  => c,
      1  => cs,
      2  => d,
      3  => ds,
      4  => e,
      5  => f,
      6  => fs,
      7  => g,
      8  => gs,
      9  => a,
      10 => as,
      11 => b }.all? { |i, pc| PitchClass.from_integer(i) == pc }.should be_true
  end
  
  it "can be constructed from an Integer >= 12" do
    PitchClass.from_integer(60).should == c
    PitchClass.from_integer(62).should == d
    # ...
    PitchClass.from_integer(71).should == b
  end
  
  it "has a String representation" do
    { c => 'c',
      d => 'd',
      e => 'e',
      f => 'f',
      g => 'g',
      a => 'a',
      b => 'b' }.all? { |pc, s| pc.to_s == s }.should be_true
  end
end

describe Sharp do
  it "is defined in terms of a natural PitchClass" do
    { cs => c,
      ds => d,
      es => e,
      fs => f,
      gs => g,
      as => a,
      bs => b }.all? { |sharp, nat| sharp == nat.sharp }.should be_true
  end
  
  it "has a rank" do
    { cs => c,
      ds => d,
      es => e,
      fs => f,
      gs => g,
      as => a,
      bs => b }.all? { |sharp, nat| sharp.rank == nat.rank + 1 }.should be_true
  end
  
  it "has a natural rank" do
    { cs => c,
      ds => d,
      es => e,
      fs => f,
      gs => g,
      as => a,
      bs => b }.all? { |sharp, nat| sharp.natural_rank == nat.rank }.should be_true
  end
  
  it "can be cast to an Integer" do
    [cs,ds,es,fs,gs,as,bs].all? { |a| a.to_i == a.rank }.should be_true
  end
  
  it "has a String representation" do
    { cs => 'cs',
      ds => 'ds',
      es => 'es',
      fs => 'fs',
      gs => 'gs',
      as => 'as',
      bs => 'bs' }.all? { |pc, s| pc.to_s == s }.should be_true
  end
end

describe Flat do
  it "is defined in terms of a natural PitchClass" do
    { cf => c,
      df => d,
      ef => e,
      ff => f,
      gf => g,
      af => a,
      bf => b }.all? { |sharp, nat| sharp == nat.flat }.should be_true
  end
  
  it "has a rank" do
    { cf => c,
      df => d,
      ef => e,
      ff => f,
      gf => g,
      af => a,
      bf => b }.all? { |a,pc| a.rank == pc.rank - 1 }.should be_true
  end
  
  it "has a natural rank" do
    { cf => c,
      df => d,
      ef => e,
      ff => f,
      gf => g,
      af => a,
      bf => b }.all? { |a,pc| a.natural_rank == pc.rank }.should be_true
  end
  
  it "can be cast to an Integer" do
    [cf,df,ef,ff,gf,af,bf].all? { |a| a.to_i == a.rank }.should be_true
  end
  
  it "has a String representation" do
    { cf => 'cf',
      df => 'df',
      ef => 'ef',
      ff => 'ff',
      gf => 'gf',
      af => 'af',
      bf => 'bf' }.all? { |pc, s| pc.to_s == s }.should be_true
  end
end

describe "PitchClasses" do
  it "has a canonical ordering" do
    [c,d,e,f,g,a,b].each do |pc|
      (pc.flat < pc).should be_true
      (pc < pc.sharp).should be_true
    end
    
    { cs => df,
      ds => ef,
      es => f,
      fs => gf,
      gs => af,
      as => bf }.all? { |x, y| x < y }.should be_true
  end
end
