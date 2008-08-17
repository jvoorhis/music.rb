require 'smf'
require 'music/midi_time'

module Music
  # Standard Midi File performance.
  class SMFWriter
    include SMF
    
    def initialize(options = {})
      @time = MidiTime.new(options.fetch(:resolution, 480))
      @seq  = Sequence.new(1, @time.resolution)
    end
    
    def track(performance, options = {})
      @track   = Track.new
      @channel = options.fetch(:channel, 1)
      seq_name = SequenceName.new(0, options.fetch(:name, gen_seq_name))
      
      @track << seq_name

      performance.each do |event|
        attack   = @time.ppqn(event.time)
        release  = attack + @time.ppqn(event.object.duration)
        pitch    = Music.MidiPitch(event.object.pitch)
        velocity = event.object.attributes[:velocity]
        @track  <<  NoteOn.new(attack, @channel, pitch, velocity)
        @track  << NoteOff.new(release, @channel, pitch, velocity)
      end
      
      @seq << @track
      
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
  end
end
