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

require 'prelude'
require 'forwardable'
require 'music/objects'
require 'music/duration'
require 'music/arrangement'
require 'music/smf_writer'

module Music
  include Duration
  include Objects
  include Arrangement
  
  module_function
  
=begin

Pitch conversion utilities.

The standard mtof and ftom functions are defined. In both of these functions,
Hertz is represented by Float, and midi pitch is represented by Integer. Two
additional helpers are also defined: Hertz and MidiPitch. Hertz accepts both
kinds of Integer and Float, but treats Integer values as midi pitch. Float
values are assumed to be in Hertz, and are not converted. The advantage is that
they can be used to implement MusicObject interpreters where Note's pitch
representation is polymorphic. 

=end
  
  # Convert midi note numbers to hertz.
  def mtof(pitch)
    440.0 * (2.0 ** ((pitch.to_f-69)/12))
  end
  
  # Convert hertz to midi note numbers.
  def ftom(pitch)
    (69 + 12 * (Math.log2(pitch / 440.0))).round
  end
  
  # Convert any pitch value to midi. 
  def MidiPitch(pitch)
    case pitch
      when Integer then pitch
      when Float then ftom(pitch)
      else raise ArgumentError, "Cannot cast #{pitch.class} to midi."
    end
  end
  
  # Convert a midi pitch value to Hertz.
  def Hertz(pitch)
    case pitch
      when Integer then mtof(pitch)
      when Float then pitch
      else raise ArgumentError, "Cannot cast #{pitch.class} to hertz."
    end
  end
  
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
    
    # Western pitch classes.
    PITCH_CLASSES = [
      new(:c, 0), new(:cs, 1),
      new(:d, 2), new(:ds, 3),
      new(:e, 4),
      new(:f, 5), new(:fs, 6),
      new(:g, 7), new(:gs, 8),
      new(:a, 9), new(:as, 10),
      new(:b, 11)
    ] unless defined?(PITCH_CLASSES)
  end
  
  class Event
    include Comparable
    
    attr_reader :time, :object
    
    def initialize(time, obj)
      @time, @object = time, obj
    end
    
    def ==(other)
      [time, object] == [other.time, other.object]
    end
    
    def <=>(other)
      time <=> other.time
    end
  end
  
  class Timeline
    extend Forwardable
    include Enumerable
    
    attr_reader :events
    def_delegators :@events, :each, :[]
    
    def self.[](*events) new(events.flatten) end
    
    def initialize(events) @events = events end
    
    def merge(other)
      Timeline[ (events + other.events).sort ]
    end
    
    def +(other)
      Timeline[ (events + other.events) ]
    end
    
    def ==(other)
      events == other.events
    end
  end
  
  class Context
    attr_reader :time, :attributes
    
    def self.default; new(0, {}) end
    
    def initialize(tim, attrs)
      @time, @attributes = tim, attrs
    end
    
    def advance(dur)
      self.class.new(time + dur, attributes)
    end
  end
  
  class Performer
    def self.perform(score) new.perform(score) end
    
    def perform(score)
      score.perform(self, Context.default).first
    end
    
    def perform_note(note, context)
      Timeline[
        Event.new(context.time,
                  Note.new(note.pitch, note.duration, note.velocity,
                           context.attributes.merge(note.attributes))) ]
    end
    
    def perform_silence(silence, context) Timeline[] end
  end
end
