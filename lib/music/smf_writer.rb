require 'smf'
require 'music/midi_time'

module Music
  class SMFWriter
    include SMF
    
    def initialize(options = {})
      @time  = MidiTime.new(options.fetch(:resolution, 480))
      @seq   = Sequence.new(1, @time.resolution)
      @tempo = SetTempo.new(1, bpm_to_qn_per_usec(options[:tempo]))
    end
    
    def track(arrangement_or_timeline, options = {})
      timeline = arrangement_or_timeline.to_timeline
      track    = Track.new
      name     = options.fetch(:name, gen_seq_name)
      
      track << SequenceName.new(0, name)
      track << @tempo
      
      timeline.each_with_time do |note, time|
        case note
          when Note: write_note(track, note, time)
          when Controller: write_controller(track, note, time)
        end
      end
      
      @seq << track
      
      self
    end
    
    def save(basename)
      filename = basename + '.mid'
      @seq.save(filename)
    end
    
    protected
      def gen_seq_name
        @seqn ||= 0
        @seqn  += 1
        "Untitled #@seqn"
      end
      
      def bpm_to_qn_per_usec(bpm)
        (60_000_000.0 / bpm).to_i
      end
      
      def write_note(track, note, time)
        attack   = @time.ppqn(time)
        release  = attack + @time.ppqn(note.duration)
        pitch    = note.pitch.to_i
        velocity = note.attributes.fetch(:velocity, 80)
        channel  = note.read(:channel) || 1
        
        track << NoteOn.new(attack, channel, pitch, velocity)
        track << NoteOff.new(release, channel, pitch, velocity)
      end
      
      def write_controller(track, ctl, time)
        offset  = @time.ppqn(time)
        channel = ctl.read(:channel) || 1
        
        track << case ctl.name.to_s
          when 'tempo'
            SetTempo.new(offset, bpm_to_qn_per_usec(ctl.tempo))
          when /^cc(0?[1-9]|1[0-6])$/
            ControlChange.new(offset, channel, $1, ctl.value)
        end
      end
  end
end
