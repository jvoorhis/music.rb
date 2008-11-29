# Encoding of Chopin's Op. 28, No 20.
# Transcribed from http://www.mutopiaproject.org/ftp/ChopinFF/O28/Chop-28-20/Chop-28-20-let.pdf

require 'music'
require 'music/midi'

include Music
include Music::MIDI

def score
# mm 1
rh = s(pn([g2, c3, ef3, g3]),
         pn([af2, c3, ef3, af3]),
         p(pn([g2, b2]),
             pn([ef3, g3], DEN) & pn([d3, f3], SN)),
         pn([ef2, g2, c3, ef3]))
lh = s(pn([c1, c2]), pn([f0, f1]), pn([g0, g1]), pn([c1, g1, c2]))

# mm 2
rh &= s(pn([ef2, af2, c3, ef3]),
          pn([f2, af2, df3, f3]),
          p(pn([df2, ef2, g2]), pn([c3, ef3], DEN) & pn([bf2, df3], SN)),
          pn([c2, ef2, g2, c3]))
lh &= s(pn([af1, af2]), pn([df1, df2]), pn([ef1, ef2]), pn([af1, af2]))

# mm 3
rh &= s(pn([d2, f2, b2, d3]),
          pn([e2, g2, bf2, c3, e3]),
          (pn([af2, c3]) | n(g3, DEN) & n(f3, SN)),
          pn([g2, c3, ef3]))
lh &= s(pn([g1, g2]), pn([c0, c1]), pn([f0, f1]), pn([c1, c2]))

# mm 4
rh &= s(pn([fs2, c3, d3]),
          pn([g2, b2, d3, g3]),
          (pn([c3, d3, fs3]) | n(b3, DEN) & n(a3, SN)),
          pn([bf2, d3, g3]))
lh &= s(pn([d1, a1, d2]), pn([g0, g1]), pn([d0, d1]), pn([g0, g1]))

# mm 5
rh &= s(pn([ef3, g3, ef4]),
          pn([ef3, af3, ef4]),
          (pn([d3, d4]) | n(af3, DEN) & n(fs3, SN)),
          pn([d3, af3, d4]))
lh &= s(pn([c1, c2]), pn([c2, c3]), pn([b1, b2]), pn([bf1, bf2]))

# mm 6
rh &= s(pn([c3, g3, c4]),
          pn([c3, d3, fs3, d4]),
          (pn([d3, g3, b3], DEN) & pn([c3, a3], SN)),
          pn([b2, d3, g3]))
lh &= s(pn([a1, a2]), pn([af1, af2]), pn([g1, g2]), pn([f1, f2]))

# mm 7
rh &= s(pn([c3, g3, c4]),
          pn([af2, c3, af3]),
          (pn([g2, d3]) | n(g3, DEN) & n(f3, SN)),
          pn([g2, c3, ef3]))
lh &= s(pn([ef1, ef2]), pn([f1, f2]), pn([b0, b1]), pn([c1, c2]))

# mm 8
rh &= s(pn([ef2, af2, c3, ef3]),
          pn([f2, af2, df3, f3]),
          (pn([f2, g2, b2]) | n(ef3, DEN) & n(d3, SN)),
          pn([ef2, g2, c3]))
lh &= s(pn([af0, af1]), pn([df0, df1]), pn([g0, g1]), pn([c0, c1]))

# mm 9
rh &= s(pn([ef3, g3, ef4]),
          pn([ef3, af3, ef3]),
          (pn([d3, d4]) | n(af3, DEN) & n(fs3, SN)),
          pn([d3, g3, d4]))
lh &= s(pn([c1, c2]), pn([c2, c3]), pn([b1, b2]), pn([bf1, bf2]))

# mm 10
rh &= s(pn([c3, g3, c4]),
          pn([c3, d3, fs3, d4]),
          (pn([d3, g3, b3], DEN) & pn([c3, a3], SN)),
          pn([b2, d3, g3]))
lh &= s(pn([a1, a2]), pn([af1, af2]), pn([g1, g2]), pn([f1, f2]))

# mm 11
rh &= s(pn([c3, g3, c4]),
          pn([af2, c3, af3]),
          (pn([g2, d3]) | n(g3, DEN) & n(f3, SN)),
          pn([g2, c3, ef3]))
lh &= s(pn([ef1, ef2]), pn([f1, f2]), pn([b0, b1]), pn([c1, c2]))

# mm 12
rh &= s(pn([ef2, af2, c3, ef3]),
          pn([f2, af2, df3, f3]),
          (pn([f2, g2, b2]) | n(ef3, DEN) & n(d3, SN)),
          pn([ef2, g2, c3]))
lh &= s(pn([af0, af1]), pn([df0, df1]), pn([g0, g1]), pn([c0, c1]))

# mm 13
rh &= pn([c3, ef3, g3, c4], 4)
lh &= pn([c2, g2], 4)

final = rh | lh
# Not all applications agree on where to begin numbering pitches. Uncomment the
# following line if it is heard an octave too low.
final.transpose(12)
end

# Write a Standard MIDI File
SMFWriter.new(:tempo => 40).
  track(score, :name => 'Op. 20, No. 2').
  save('chopin-op28-no20')

# Play using the builtin synth on OS X
# require 'music/midi/player'
# MIDI::Player.play(score, :tempo => 56, :driver => :dls_synth)
