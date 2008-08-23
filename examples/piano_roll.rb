require 'music'
require 'rubygems'
require 'builder'

class PianoRoll
  def initialize(music, options = {})
    @timeline = music.to_timeline
    @duration = music.duration.to_f
    @w        = options.fetch(:width, 24.0)
    @h        = options.fetch(:height, 20.0)
    @xml      = Builder::XmlMarkup.new
    
    draw
  end
  
  def to_s
    @xml.target!
  end
  
  private
    def draw
      @xml.instruct!
      @xml.svg('xmlns'   => 'http://www.w3.org/2000/svg',
               'version' => '1.1',
               'width'   => cm(@w),
               'height'  => cm(@h)) do
        @timeline.each_with_time do |n, t|
          x = @w * (t / @duration)
          y = @h - (@h * n.pitch.quo(128))
          w = @w * (n.duration / @duration)
          h = @h * 1.quo(128)
          @xml.rect('x'      => cm(x),
                    'y'      => cm(y),
                    'width'  => cm(w),
                    'height' => cm(h),
                    'fill'   => 'red')
        end
      end
    end
    
    def cm(n); "%2.2fcm" % n.to_f end
end

if __FILE__ == $0
  load File.join(File.dirname(__FILE__), 'chopin.rb')
  
  open('example.svg', 'w') do |f|
    f.write(PianoRoll.new(score).to_s)
  end
end
