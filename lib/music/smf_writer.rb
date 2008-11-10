require 'rubygems'
require 'midilib'

module Music
  class SMFWriter
    include ::MIDI
    
    def initialize(options = {})
      @seq   = Sequence.new
      @tempo = Tempo.new(Tempo.bpm_to_mpq(options[:tempo]))
    end
    
    def track(arrangement_or_timeline, options = {})
      timeline = arrangement_or_timeline.to_timeline
      track    = Track.new(@seq)
      channel  = options.fetch(:channel, 1)
      name     = options.fetch(:name, gen_seq_name)
      
      track.events << MetaEvent.new(META_SEQ_NAME, name)
      track.events << @tempo
      
      timeline.each_with_time do |note, time|
        attack   = @seq.length_to_delta(time)
        release  = @seq.length_to_delta(note.duration)
        pitch    = note.pitch.to_i
        velocity = note.attributes.fetch(:velocity, 80)
        
        track.merge [
          NoteOnEvent.new(channel, pitch, velocity, attack),
          NoteOffEvent.new(channel, pitch, velocity, release)
        ]
      end
      
      @seq.tracks << track
      
      self
    end
    
    def save(basename)
      filename = 'midilib' + basename + '.mid'
      open(filename, 'wb') { |f| @seq.write(f) }
    end
    
    protected
      def gen_seq_name
        @seqn ||= 0
        @seqn  += 1
        "Untitled #@seqn"
      end
  end
end
