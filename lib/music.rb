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
require 'music/duration'
require 'music/pitch'
require 'music/key'
require 'music/objects'
require 'music/score'
require 'music/interpreter'
require 'music/timeline'
require 'music/smf_writer'

module Music
  include Duration
  include Objects
  include Score
  
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
  
  # Convert a midi pitch value to Hertz.
  def Hertz(pitch)
    case pitch
      when Integer then mtof(pitch)
      when Float then pitch
      else raise ArgumentError, "Cannot cast #{pitch.class} to hertz."
    end
  end
  
=begin

Music constructors.

A piece of music may be constructed by calling note(), silence(), rest() and
group(). It is recommended that you use these methods rather than instantiating
the items directly, e.g. via Music::Objects::Note.new. These functions are both
more convenient, and decouple your composition from the underlying
representation, which is subject to change.

=end
  
  # Arrange a note.
  def note(pit, dur = 1, attrs = {})
    Item.new(Note.new(pit, dur, attrs))
  end
  alias n note
  
  # Arrange silence.
  def silence(dur = 1, attrs = {})
    Item.new(Silence.new(dur, attrs))
  end
  alias rest silence
  
  # Arrange a group.
  def group(mus, attrs)
    Group.new(mus, attrs)
  end
  
  # A blank arrangement of zero length. This is the identity for parallel
  # and serial composition.
  def none; silence(0) end
  
=begin

Music combinators.

line() and chord() both accept Enumerable lists of Arrangements, and combine
them into a new Arrangement.

=end
  
  # Compose a list of arrangements sequentially.
  def line(*ms)
    ms.inject { |a, b| a & b }
  end
  
  # Compose a list of arrangements in parallel.
  def chord(*ms)
    ms.inject { |a, b| a | b }
  end
end
