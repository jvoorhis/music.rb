require 'music'
require 'rubygems'
require 'builder'

class PianoRoll
  def initialize(music, options = {})
    @timeline   = music.to_timeline
    @duration   = music.duration.to_f
    @w          = options.fetch(:width, 24.0)
    @h          = options.fetch(:height, 12.0)
    ps          = @timeline.map(&:pitch)
    @minp       = ps.min
    @maxp       = ps.max
    @rangep     = @maxp - @minp
    @xml        = Builder::XmlMarkup.new(:indent => 2)
    @standalone = options.fetch(:standalone, true)
    
    draw
  end
  
  def to_s; @xml.target! end
  
  private
    def draw
      @xml.instruct! if @standalone
      @xml.svg(:svg,
               'xmlns:svg' => 'http://www.w3.org/2000/svg',
               'version'   => '1.1',
               'width'     => cm(@w),
               'height'    => cm(@h)) do
        draw_grid
        draw_notes
      end
    end
    
    def draw_grid
      @minp.upto(@maxp) do |p|
        x    = 0
        y    = @h - (@h * (p - @minp + 1).quo(@rangep))
        w    = @w
        h    = @h * 1.quo(@rangep)
        fill = if (p % 2).zero? then '#ddddff' else '#d8d8d8' end
        @xml.svg(:rect,
                 'x'      => cm(x),
                 'y'      => cm(y),
                 'width'  => cm(w),
                 'height' => cm(h),
                 'fill'   => fill)
      end
    end
    
    def draw_notes
      @timeline.each_with_time do |n, t|
        x    = @w * (t / @duration)
        y    = @h - (@h * (n.pitch - @minp + 1).quo(@rangep))
        w    = @w * (n.duration / @duration)
        h    = @h * 1.quo(@rangep)
        fill = '#ff0000'
        @xml.svg(:rect,
                 'x'      => cm(x),
                 'y'      => cm(y),
                 'width'  => cm(w),
                 'height' => cm(h),
                 'fill'   => fill)
      end
    end
    
    def cm(n) "%2.2fcm" % n.to_f end
end

if __FILE__ == $0
  load File.join(File.dirname(__FILE__), 'chopin.rb')
  
  open('chopin.svg', 'w') do |f|
    f.write(PianoRoll.new(score).to_s)
  end
end
