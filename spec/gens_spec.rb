require File.join( File.dirname(__FILE__), 'spec_helper')

describe Gen do
  before(:all) do
    @score = s( n(c4, 1),
                :amp => gen { |c| 0.5 })
  end
  
  it "should generate values from the given context" do
    timeline = @score.to_timeline
    timeline[0].amp.should == 0.5
  end
end

describe Tr do
  before(:all) do
    @score = s( n(c4, 1, :amp => 0.5),
                :amp => tr { |amp| amp * 0.5 } )
  end
  
  it "should transform attribute values" do
    timeline = @score.to_timeline
    timeline[0].amp.should == 0.25
  end
end

describe Env do
  it "should transform attribute values based on their phase" do
    score = s( seq(n([c4, e4, g4], 1, :amp => 0.5)),
                :amp => env { |value, phase| value * Math.sin(phase) } )
    timeline = score.to_timeline
    timeline[0].amp.should == 0.0
    timeline[1].amp.should be_close(0.1636, 0.0001)
    timeline[2].amp.should be_close(0.3092, 0.0001)
  end
  
  it "can be used to implement various transforms" do
    score = cresc(2,
              seq(n([c4, e4, g4], 1, :velocity => 64)))
    timeline = score.to_timeline
    timeline[0].velocity.should == 64
    timeline[1].velocity.should == 85
    timeline[2].velocity.should == 106
  end
  
  def cresc(factor, score)
    s(score, :velocity => env { |vel, ph|
        multiplier = (factor - 1.0) * (1.0 + ph)
        (vel * multiplier).to_i
      })
  end
end
