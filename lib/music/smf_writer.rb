require 'smf'
require 'music/midi_time'

module Music
  class SMFWriter
    include SMF
    
    def initialize(options = {})
      @time  = MidiTime.new(options.fetch(:resolution, 480))
      @seq   = Sequence.new(1, @time.resolution)
      @tempo = SetTempo.new(1, bpm_to_qn_per_usec(
                                   options.fetch(:tempo, 2000000)))
    end
    
    def track(arrangement_or_timeline, options = {})
      timeline = arrangement_or_timeline.to_timeline
      track    = Track.new
      channel  = options.fetch(:channel, 1)
      name     = options.fetch(:name, gen_seq_name)
      
      track << SequenceName.new(0, name)
      track << @tempo
      
      timeline.each_with_time do |note, time|
        attack   = @time.ppqn(time)
        release  = attack + @time.ppqn(note.duration)
        pitch    = Music.MidiPitch(note.pitch)
        velocity = note.attributes.fetch(:velocity, 80)
        
        track  << NoteOn.new(attack, channel, pitch, velocity)
        track  << NoteOff.new(release, channel, pitch, velocity)
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
        ((bpm/60.0) * 1_000_000).to_i
      end
  end
end
