require File.join(File.dirname(__FILE__), 'spec_helper')
require 'music/csound'

describe Csound::ScoreWriter do
  before(:all) do
    @score  = group(
                sn([c4, g4, c5]) | sn([c3, g2, c2]),
                :instrument => 101)
    @writer = Csound::ScoreWriter.new(
                :instruments => {
                  101 => [:pitch]
                })
  end
  
  it "should write a valid Csound score" do
    File.should_receive(:open).and_yield(f = mock_file)
    @writer.write(@score)
    f.buf.should == <<SCO
i 101	0	1	8.00
i 101	0	1	7.00
i 101	1	1	6.07
i 101	1	1	8.07
i 101	2	1	9.00
i 101	2	1	6.00
SCO
  end
  
  def mock_file
    Class.new {
      def buf; @buf ||= "" end
      def write(str) buf << str end
    }.new
  end
end
