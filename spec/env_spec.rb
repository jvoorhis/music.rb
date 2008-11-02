require File.join( File.dirname(__FILE__), 'spec_helper')

describe Env do
  def cresc(factor, score)
    group(score,
      :velocity => env { |v0, ph|
         v1 = (v0 + ph * ((v0 * factor) - v0)).round # Linear interpolation
         v1.clip(0..127) })
  end
  
  it "can be used to implement various transforms" do
    score = cresc(2,
              sn([c4, e4, g4], 1, :velocity => 64))
    timeline = score.to_timeline
    timeline.map(&:velocity).should == [64, 96, 127]
  end
  
  it "can be nested" do
    score = cresc(1.5,
              sn([c4, e4, g4], 1, :velocity => 40) &
              cresc(1.5,
                sn([c4, e4, g4], 1, :velocity => 40)))
    timeline = score.to_timeline
    timeline.map(&:velocity).should == [40, 47, 53, 60, 83, 110]
  end
end
