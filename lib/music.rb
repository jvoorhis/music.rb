# music.rb is symbolic musical computation for Ruby.
# Copyright (C) 2008 Jeremy Voorhis <jvoorhis@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'forwardable'
require 'rational'

module Music
  
  module_function
  def log2(x)
    Math.log(x) / Math.log(2)
  end
  
  # Convert midi note numbers to hertz
  def mtof(pitch)
    440.0 * (2.0 ** ((pitch.to_f-69)/12))
  end
  
  # Convert hertz to midi note numbers
  def ftom(pitch)
    (69 + 12 * (log2(pitch / 440.0))).round
  end
  
  # Cast pitch value as a midi pitch number.
  def MidiPitch(pitch)
    case pitch
      when Integer then pitch
      when Float then ftom(pitch)
      else raise ArgumentError, "Cannot cast #{pitch.class} to midi."
    end
  end
  
  # Cast pitch value as hertz.
  def Hertz(pitch)
    case pitch
      when Integer then mtof(pitch)
      when Float then pitch
      else raise ArgumentError, "Cannot cast #{pitch.class} to hertz."
    end
  end
  
  # Construct a Note.
  def note(pit, dur=1, vel=100)
    Note.new(pit, dur, vel)
  end
  
  # Construct a Silence.
  def silence(dur=1)
    Silence.new(dur)
  end
  alias :rest :silence
  
  # Compose a list of MusicObjects sequentially.
  def line(*objs)
    objs.inject { |a, b| a & b }
  end
  
  # Compose a list of MusicObjects in parallel.
  def chord(*objs)
    objs.inject { |a, b| a | b }
  end
  
  def delay(dur, obj)
    silence(dur) & obj
  end
  
  # Pluggable random number generator support. The default RNG may be
  # replaced, e.g. for deterministic unit testing.
  class RNG
    def rand; Kernel.rand end
  end
  def Music.rng; @rng end
  def Music.rng=(rng) @rng = rng end
  Music.rng = RNG.new
  
  def Music.rand; Music.rng.rand end
  
  class Pitch
    attr_reader :pitch_class, :octave
    def initialize(pc, oct)
      @pitch_class, @octave = pc, oct
    end
  end
  
  class PitchClass
    include Comparable
    
    def self.for(pitch)
      PITCH_CLASSES.detect { |pc| pc.ord == pitch % 12 }
    end
    
    attr_reader :name, :ord
    
    def initialize(name, ord)
      @name, @ord = name, ord
    end
    
    def <=>(pc) ord <=> pc.ord end
    
    def to_s; name.to_s end
    
    # Western pitch classes. Accidental note names borrowed from LilyPond.
    PITCH_CLASSES = [
      new(:c, 0), new(:cis, 1),
      new(:d, 2), new(:dis, 3),
      new(:e, 4),
      new(:f, 5), new(:fis, 6),
      new(:g, 7), new(:gis, 8),
      new(:a, 9), new(:ais, 10),
      new(:b, 11)
    ] unless defined?(PITCH_CLASSES)
  end
  
  class MusicObject
    
    def duration; 0 end
    
    # Sequential composition.
    def seq(other)
      Seq.new(self, other)
    end
    alias :& :seq
    
    # Parallel (concurrent) composition.
    def par(other)
      Par.new(self, other)
    end
    alias :| :par
    
    def perform(performer, context)
      raise NotImplementedError, "Subclass responsibility"
    end
    
    def to_a; [self] end
  end
  
  class Seq < MusicObject
    attr_reader :left, :right
    
    def initialize(left, right)
      @left, @right = left, right
    end
    
    def ==(other)
      case other
        when Seq
          left == other.left && right == other.right
        else false
      end
    end
    
    def duration
      left.duration + right.duration
    end
    
    def perform(performer, context)
      left.perform(performer, context) + right.perform(performer, context.advance(left.duration))
    end
    
    def to_a
      left.to_a + right.to_a
    end
  end
  
  class Par < MusicObject
    attr_reader :top, :bottom
    
    def initialize(top, bottom)
      @top, @bottom = top, bottom
    end
    
    def ==(other)
      case other
        when Par
          top == other.top && bottom == other.bottom
        else false
      end
    end
    
    def duration
      [top.duration, bottom.duration].max
    end
    
    def perform(performer, context)
      top.perform(performer, context).merge( bottom.perform(performer, context) )
    end
  end
  
  class Group < MusicObject
    extend Forwardable
    def_delegators :@music, :duration
    attr_reader :music, :attributes
    
    def initialize(music, attributes = {})
      @music, @attributes = music, attributes
    end
    
    def ==(other)
      case other
        when Group: @music == other.music
        else false
      end
    end
  end
  
  # Remain silent for the duration.
  class Silence < MusicObject
    attr_reader :duration, :attributes
    
    def initialize(duration, attributes = {})
      @duration, @attributes = duration, attributes
    end
    
    def ==(other)
      case other
        when Silence: @duration == other.duration
        else false
      end
    end
    
    def perform(performer, context)
      performer.perform_silence(self, context)
    end
  end
  Rest = Silence unless defined?(Rest) # Type alias for convenience
  
  # A note has a steady pitch and a duration.
  class Note < MusicObject
    attr_reader :pitch, :duration, :effort, :attributes
    
    def initialize(pitch, duration, effort, attributes = {})
      @pitch      = pitch
      @duration   = duration
      @effort     = effort
      @attributes = attributes
    end
    
    def ==(other)
      case other
        when Note
          [@pitch, @duration, @effort] == [other.pitch, other.duration, other.effort]
        else false
      end
    end
    
    def pitch_class
      PitchClass.for(@pitch)
    end
    
    def transpose(hsteps, dur=self.duration, eff=self.effort)
      self.class.new(pitch+hsteps, dur, eff)
    end
    
    def perform(performer, context)
      performer.perform_note(self, context)
    end
  end
  
  class Event
    include Comparable
    
    attr_reader :time, :object
    
    def initialize(time, obj)
      @time, @object = time, obj
    end
    
    def <=>(ev)
      @time <=> ev.time
    end
  end
  
  class Context
    attr_reader :time
    
    def initialize(time)
      @time = time
    end
    
    def advance(dur)
      Context.new( @time + dur )
    end
  end
  
  class Performance < Array
    def merge(other) (self + other.to_performance).sort end
  end
  
  class ::Array
    def merge(other) to_performance.merge(other) end
    def to_performance; Performance[*self] end
  end
  
  class Performer
    def perform(score)
      ctx = Context.new(0)
      score.perform(self, ctx)
    end
    
    def perform_note(note, context)
      Performance[ Event.new(context.time, note) ]
    end
    
    def perform_silence(silence, context) Performance[] end
  end
  
  class MidiTime
    attr :resolution
    
    def initialize(res)
      @resolution = res
    end
    
    def ppqn(val)
      case val
        when Numeric
          (val * resolution).round
        else
          raise ArgumentError, "Cannot convert #{val}:#{val.class} to midi time."
      end
    end
  end
  
  require 'smf'
  
  # Standard Midi File performance.
  class SMFTranscription
    include SMF
    
    def initialize(options={})
      @time = MidiTime.new(options.fetch(:resolution, 480))
      @seq  = Sequence.new(1, @time.resolution)
    end
    
    def write(performance, options={})
      @track = Track.new
      seq_name = options.fetch(:name, gen_seq_name)
      @track << SequenceName.new(0, seq_name)
      @channel = options.fetch(:channel, 1)
      
      performance.each do |event|
        attack  = @time.ppqn(event.time)
        release = attack + @time.ppqn(event.object.duration)
        @track << NoteOn.new(attack, @channel, Music.MidiPitch(event.object.pitch), event.object.effort)
        @track << NoteOff.new(release, @channel, Music.MidiPitch(event.object.pitch), event.object.effort)
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
