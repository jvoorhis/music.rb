require File.join( File.dirname(__FILE__), 'spec_helper')

describe Env do
  def cresc(factor, score)
    s(score, :velocity => env { |vel, ph|
        multiplier = (factor - 1.0) * (1.0 + ph)
        (vel * multiplier).to_i
      })
  end
  
  it "can be used to implement various transforms" do
    score = cresc(2,
              seq(n([c4, e4, g4], 1, :velocity => 64)))
    timeline = score.to_timeline
    timeline[0].velocity.should == 64
    timeline[1].velocity.should == 85
    timeline[2].velocity.should == 106
  end
  
  it "can be nested" do
    score = cresc(2,
              seqn([c4, e4, g4], 1, :velocity => 40) &
              cresc(2,
                seqn([c4, e4, g4], 1, :velocity => 40)))
    timeline = score.to_timeline
    timeline.map(&:velocity).should == [40, 46, 53, 60, 88, 121]
  end
end
