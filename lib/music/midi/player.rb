require 'midiator'
require 'music/midi/scheduler'

module Music
  module MIDI
    
    class Player
      include MIDIator
      
      def self.play(score, options)
        player = new(options)
        player.play(score, true)
        nil
      end
      
      def initialize(options = {})
        @options = options
        @midi    = Interface.new
        if driver = options[:driver]
          @midi.use(driver)
        else
          @midi.autodetect_driver
        end
      end
      
      def play(timeline_or_score, blocking = false)
        timeline  = timeline_or_score.to_timeline
        scheduler = Scheduler.new(
                       :resolution => @options[:resolution],
                       :tempo      => @options[:tempo])
        
        timeline.each_with_time do |obj, time|
          case obj
            when Note: play_note(scheduler, time, obj)
            when Controller: play_controller(scheduler, time, obj)
          end
        end
        
        if blocking
          last = timeline.events.last
          shutdown_time = last.time + last.object.duration
          scheduler.at(shutdown_time) { scheduler.thread.kill }
          scheduler.thread.join
        end
        nil
      end
      
      private
        def play_note(scheduler, time, note)
          att = time
          rel = time + note.duration
          chn = note.fetch(:channel, 1)
          vel = note.fetch(:velocity, 64)
          pit = note.pitch.to_i
          scheduler.at(att) { @midi.note_on(pit, chn, vel) }
          scheduler.at(rel) { @midi.note_off(pit, chn, 0) }
        end

        def play_controller(scheduler, time, ctl)
          case ctl.name
            when :cc
              scheduler.at(time) {
                @midi.control_change(ctl.number, ctl.channel, ctl.value)
              }
            when :tempo
              scheduler.at(time) { scheduler.tempo = ctl.tempo }
          end
        end
    end
  end
end
