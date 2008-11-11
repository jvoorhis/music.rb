require File.join(File.dirname(__FILE__), 'spec_helper')
require 'music/csound'

include Csound

describe ScoreWriter do
  before(:all) do
    @score  = group(
                sn([c4, g4, c5]) | sn([c3, g2, c2]),
                :instrument => 101)
    @writer = ScoreWriter.new(
                :f => [
                  [1, 0, 0, 1, "example.wav", 0, 0, 0]
                ],
                :i => {
                  101 => [:pitch]
                })
  end
  
  it "should write a valid Csound score" do
    File.should_receive(:open).and_yield(f = StubFile.new)
    @writer.write(@score)
    f.buf.should == <<SCO
f 1	0	0	1	example.wav	0	0	0

i 101	0	1	8.00
i 101	0	1	7.00
i 101	1	1	6.07
i 101	1	1	8.07
i 101	2	1	9.00
i 101	2	1	6.00
SCO
  end
  
  class StubFile
    def buf; @buf ||= "" end
    def write(str) buf << str end
  end
end
