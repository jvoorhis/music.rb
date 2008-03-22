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
  
  class PitchClass < Struct.new(:name, :ord)
    def to_s; name.to_s end
  end
  
  # Western pitch classes. Accidental note names borrowed from LilyPond.
  PITCH_CLASSES = [
    PitchClass[:c, 0],
    PitchClass[:cis, 1],
    PitchClass[:d, 2],
    PitchClass[:dis, 3],
    PitchClass[:e, 4],
    PitchClass[:f, 5],
    PitchClass[:fis, 6],
    PitchClass[:g, 7],
    PitchClass[:gis, 8],
    PitchClass[:a, 9],
    PitchClass[:ais, 10],
    PitchClass[:b, 11]
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
  class Rest < MusicEvent
    attr :duration
    
    def initialize(duration)
      @duration = duration
    end
    
    def perform(performance)
      performance.play_rest(self)
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
    def note(pitch, duration=0.5)
      Note.new(pitch, duration)
    end
    
    def rest(duration=0.5)
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
  
  module Performance
    
    class OSC
      def initialize(score)
        @score = score
      end
      
      def perform
        @score.each { |event| event.play(self) }
      end
      
      def play_note; end
      
      def play_rest; end
    end
  end
end

if __FILE__ == $0
  def random_voice
    Music::Voice.new do |voice|
      voice >> (lbl=note(60)) >> note(62) >> note(64) >> choice(lbl, note(62)) >> note(60)
    end
  end
  
  puts random_voice.map { |note| note.pitch_class } * ', '
end
