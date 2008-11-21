require 'midiator'

module Music
  module MIDI
    
    class Player
      include MIDIator
      
      def initialize(defaults = {})
        @i   = Interface.new
        @t   = Timer.new(defaults.fetch(:resolution, 0.001))
        @bpm = defaults.fetch(:tempo, 120)
        @i.autodetect_driver
      end
      
      def join; @t.thread.join end
      
      def play(timeline_or_score)
        timeline = timeline_or_score.to_timeline
        now = Time.now.to_f
        timeline.each_with_time do |obj, time|
          case obj
            when Note
              att = now + (time * (60.0 / @bpm))
              rel = att + (obj.duration * (60.0 / @bpm))
              chn = obj.read(:channel)  || 1
              vel = obj.read(:velocity) || 64
              @t.at(att) { @i.note_on(obj.pitch.to_i, chn, vel) }
              @t.at(rel) { @i.note_off(obj.pitch.to_i, chn, 0) }
          end
        end
        nil
      end
    end
  end
end
