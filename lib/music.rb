# music.rb is symbolic musical computation for Ruby.
# Copyright (C) 2008 Jeremy Voorhis
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

class Array
  def rand
    self[(Kernel::rand * size).floor]
  end
end

module Music
  
  def self.log2(x)
    Math.log(x) / Math.log(2)
  end 
  
  # Convert midi note numbers to hertz
  def self.mtof(pitch)
    440.0 * (2 ** (((pitch)-69)/12))
  end
  
  # Convert hertz to midi note numbers
  def self.ftom(pitch)
    (69 + 12 * (log2(pitch / 440.0))).round
  end
  
  # Cast pitch value as a midi note number.
  def self.Midi(pitch)
    case pitch
      when Integer then pitch 
      when Float then ftom(pitch)
      else raise ArgumentError, "Cannot cast #{pitch.class} to midi."
    end
  end
  
  # Cast pitch value as hertz.
  def self.Hertz(pitch)
    case pitch
      when Integer then mtof(pitch)
      when Float then pitch
      else raise ArgumentError, "Cannot cast #{pitch.class} to hertz."
    end
  end
  
  class PitchClass
    include Comparable
    
    attr_reader :name, :ord
    
    def initialize(name, ord)
      @name, @ord = name, ord
    end
    
    def <=>(pc) ord <=> pc.ord end
    
    def to_s; name.to_s end
  end
  
  # Western pitch classes. Accidental note names borrowed from LilyPond.
  PITCH_CLASSES = [
    PitchClass.new(:c, 0),
    PitchClass.new(:cis, 1),
    PitchClass.new(:d, 2),
    PitchClass.new(:dis, 3),
    PitchClass.new(:e, 4),
    PitchClass.new(:f, 5),
    PitchClass.new(:fis, 6),
    PitchClass.new(:g, 7),
    PitchClass.new(:gis, 8),
    PitchClass.new(:a, 9),
    PitchClass.new(:ais, 10),
    PitchClass.new(:b, 1)
  ]
  
  class MusicEvent
    # Return the next MusicEvent in its prepared state.
    def next
      @next.prepare if @next
    end
    
    # Sequence +event+ after this event.
    def >>(event)
      @next = event
    end
    
    def has_next?
      !@next.nil?
    end
    
    # Prepare the event for its performance.
    def prepare; self end
    
    # Call +MusicEvent#perform+ with a performance visitor.
    def perform(performance)
      raise NotImplementedError, "Subclass responsibility"
    end
  end
  
  # A note has a steady pitch and a duration.
  class Note < MusicEvent
    attr_reader :pitch, :duration
    
    def initialize(pitch, duration)
      @pitch, @duration = pitch, duration
    end
    
    def perform(performance)
      performance.play_note(self)
    end
    
    def pitch_class
      PITCH_CLASSES.detect { |pc| pc.ord == pitch % 12 }
    end
  end
  
  # Remain silent for the duration.
  class Silence < MusicEvent
    attr :duration
    
    def initialize(duration)
      @duration = duration
    end
    
    def perform(performance)
      performance.play_silence(self)
    end
  end
  
  # Choose randomly from given events.
  class Choice < MusicEvent
    def initialize(*choices)
      @choices = choices
    end
    
    def prepare
      event = @choices.rand
      unless event.has_next?
        event = event.dup
        event >> @next
      end
      event.prepare
    end
  end
  
  ::Kernel.module_eval do
    def note(pitch, duration=128)
      Note.new(pitch, duration)
    end
    
    def rest(duration=128)
      Rest.new(duration)
    end
    
    def choice(*events)
      Choice.new(*events)
    end
  end
  
  class Voice
    include Enumerable
    
    attr :start_event
    
    def initialize; yield self end
    
    def >>(event)
      @start_event = event
    end
    
    def each
      return if @start_event.nil?
      current_event = @start_event

      begin
        yield current_event
      end while current_event = current_event.next
    end
  end
  
  require 'smf'
  
  # Standard Midi File performance.
  class SMFPerformance
    include SMF
    
    def initialize(voice, seq_name)
      @voice = voice
      @filename = seq_name + '.mid'
      @seq = Sequence.new
      @track = Track.new
      @seq << @track
      @track << SequenceName.new(0, seq_name)
      @channel = 1
      @offset = 0
    end
    
    def perform
      @voice.each { |event| event.perform(self) }
      self
    end
    
    def save
      @seq.save(@filename)
    end
    
    def play_note(ev)
      @track << NoteOn.new(@offset, @channel, Music.Midi(ev.pitch), 64)
      @offset += ev.duration
      @track << NoteOff.new(@offset, @channel, Music.Midi(ev.pitch), 64)
    end
    
    def play_silence(ev)
      @offset += ev.duration
    end
  end
end

if __FILE__ == $0
  def random_voice
    Music::Voice.new do |voice|
      voice >> (lbl=note(60)) >> note(62) >> note(64) >> choice(lbl, note(62)) >> note(60)
    end
  end
  
  voice = random_voice
  puts voice.map { |note| note.pitch_class } * ', '
  
  Music::SMFPerformance.new(voice, 'example').perform.save
end
