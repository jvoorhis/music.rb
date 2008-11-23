require 'midiator'

module Music
  module MIDI
    
    class Player
      include MIDIator
      
      def self.play(score, options)
        player = new(options)
        player.play(score, true)
        player.join if options.fetch(:block, true)
        nil
      end
      
      attr :timer
      
      def initialize(options = {})
        @midi  = Interface.new
        @timer = Timer.new(options.fetch(:resolution, 0.001))
        @bpm   = options.fetch(:tempo, 120)
        if driver = options[:driver]
          @midi.use(driver)
        else
          @midi.autodetect_driver
        end
      end
      
      def join; @timer.thread.join end
      
      def play(timeline_or_score, shutdown = false)
        timeline = timeline_or_score.to_timeline
        now = Time.now.to_f
        timeline.each_with_time do |obj, time|
          case obj
            when Note: play_note(now, time, obj)
            when Controller: play_controller(now, time, obj)
          end
        end
        
        if shutdown
          last = timeline.events.last
          shutdown_at = now + offset(last.time + last.object.duration)
          @timer.at(shutdown_at) { Thread.current.kill }
        end
        nil
      end
      
      private
        def play_note(now, time, note)
          att = now + offset(time)
          rel = att + offset(note.duration)
          chn = note.fetch(:channel, 1)
          vel = note.fetch(:velocity, 64)
          pit = note.pitch.to_i
          @timer.at(att) { @midi.note_on(pit, chn, vel) }
          @timer.at(rel) { @midi.note_off(pit, chn, 0) }
        end

        def play_controller(note, time, ctl)
          case obj.name
            when :cc
              @timer.at offset(time) do
                @midi.control_change(obj.number, obj.channel, obj.value)
              end
          end
        end

        def offset(time)
          time * (60.0 / @bpm)
        end
    end
  end
end
