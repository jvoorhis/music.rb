# An implementation of Bjorklund's algorithm applied to rhythm.
# Inspired by http://ruinwesen.com/blog?id=216

require 'music'
require 'music/midi'

include Music
include Music::MIDI

module Euclid
  module_function
  def euclid(k, n)
    raise ArgumentError, "`k' must be less than `n'" unless k < n
    bjorklund Array.new(k, [true]) + Array.new(n - k, [false])
  end
  
  def bjorklund(seqs)
    real, rem = split_rem(seqs)
    if rem.size <= 1
      (real + rem).flatten
    else
      bjorklund(interleave(real, rem))
    end
  end
  
  def split_rem(seq)
    rem, real  = seq.partition { |x| x == seq.last }
    if rem.size == real.size
      return seq, []
    else
      return real, rem
    end
  end
  
  def interleave(list1, list2)
    res = []
    l1  = list1.dup
    l2  = list2.dup
    until l1.empty? && l2.empty?
      e1 = l1.shift || []
      e2 = l2.shift || []
      res.push(e1 + e2)
    end
    res
  end
end

def kick(*args)
  n(35, *args)
end

def snare(*args)
  n(38, *args)
end

def rhythm(k, n)
  bits = Euclid.euclid(k, n)
  s(bits.map { |pulse| pulse ? kick(SN) : r(SN) }) * 2
end

def tick
  (r & snare(1)) * 2
end

def score
  ks = rhythm(2, 4) & rhythm(3, 12) & rhythm(2, 3) & rhythm(3, 13)
  ss = tick * 4
  ks | ss
end

SMFWriter.new(:tempo => 136).
  track(score, :name => 'Euclidean Etude').
  save('euclid')
