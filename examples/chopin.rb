# Encoding of Chopin's Op. 28, No 20.
# 'Funeral March'
# Transcribed from http://www.mutopiaproject.org/ftp/ChopinFF/O28/Chop-28-20/Chop-28-20-let.pdf

require 'music'

include Music

def score
# mm 1
rh = seq(parn([g2, c3, ef3, g3]),
         parn([af2, c3, ef3, af3]),
         par(parn([g2, b2]), parn([ef3, g3], DEN) & parn([d3, f3], SN)),
         parn([ef2, g2, c3, ef3]))
lh = seq(parn([c1, c2]), parn([f0, f1]), parn([g0, g1]), parn([c1, g1, c2]))

# mm 2
rh &= seq(parn([ef2, af2, c3, ef3]),
          parn([f2, af2, df3, f3]),
          (parn([df2, ef2, g2]) | parn([c3, ef3], DEN) & parn([bf2, df3], SN)),
          parn([c2, ef2, g2, c3]))
lh &= seq(parn([af1, af2]), parn([df1, df2]), parn([ef1, ef2]), parn([af1, af2]))

# mm 3
rh &= seq(parn([d2, f2, b2, d3]),
          parn([e2, g2, bf2, c3, e3]),
          (parn([af2, c3]) | n(g3, DEN) & n(f3, SN)),
          parn([g2, c3, ef3]))
lh &= seq(parn([g1, g2]), parn([c0, c1]), parn([f0, f1]), parn([c1, c2]))

# mm 4
rh &= seq(parn([fs2, c3, d3]),
          parn([g2, b2, d3, g3]),
          (parn([c3, d3, fs3]) | n(b3, DEN) & n(a3, SN)),
          parn([bf2, d3, g3]))
lh &= seq(parn([d1, a1, d2]), parn([g0, g1]), parn([d0, d1]), parn([g0, g1]))

# mm 5
rh &= seq(parn([ef3, g3, ef4]),
          parn([ef3, af3, ef4]),
          (parn([d3, d4]) | n(af3, DEN) & n(fs3, SN)),
          parn([d3, af3, d4]))
lh &= seq(parn([c1, c2]), parn([c2, c3]), parn([b1, b2]), parn([bf1, bf2]))

# mm 6
rh &= seq(parn([c3, g3, c4]),
          parn([c3, d3, fs3, d4]),
          (parn([d3, g3, b3], DEN) & parn([c3, a3], SN)),
          parn([b2, d3, g3]))
lh &= seq(parn([a1, a2]), parn([af1, af2]), parn([g1, g2]), parn([f1, f2]))

# mm 7
rh &= seq(parn([c3, g3, c4]),
          parn([af2, c3, af3]),
          (parn([g2, d3]) | n(g3, DEN) & n(f3, SN)),
          parn([g2, c3, ef3]))
lh &= seq(parn([ef1, ef2]), parn([f1, f2]), parn([b0, b1]), parn([c1, c2]))

# mm 8
rh &= seq(parn([ef2, af2, c3, ef3]),
          parn([f2, af2, df3, f3]),
          (parn([f2, g2, b2]) | n(ef3, DEN) & n(d3, SN)),
          parn([ef2, g2, c3]))
lh &= seq(parn([af0, af1]), parn([df0, df1]), parn([g0, g1]), parn([c0, c1]))

# mm 9
rh &= seq(parn([ef3, g3, ef4]),
          parn([ef3, af3, ef3]),
          (parn([d3, d4]) | n(af3, DEN) & n(fs3, SN)),
          parn([d3, g3, d4]))
lh &= seq(parn([c1, c2]), parn([c2, c3]), parn([b1, b2]), parn([bf1, bf2]))

# mm 10
rh &= seq(parn([c3, g3, c4]),
          parn([c3, d3, fs3, d4]),
          (parn([d3, g3, b3], DEN) & parn([c3, a3], SN)),
          parn([b2, d3, g3]))
lh &= seq(parn([a1, a2]), parn([af1, af2]), parn([g1, g2]), parn([f1, f2]))

# mm 11
rh &= seq(parn([c3, g3, c4]),
          parn([af2, c3, af3]),
          (parn([g2, d3]) | n(g3, DEN) & n(f3, SN)),
          parn([g2, c3, ef3]))
lh &= seq(parn([ef1, ef2]), parn([f1, f2]), parn([b0, b1]), parn([c1, c2]))

# mm 12
rh &= seq(parn([ef2, af2, c3, ef3]),
          parn([f2, af2, df3, f3]),
          (parn([f2, g2, b2]) | n(ef3, DEN) & n(d3, SN)),
          parn([ef2, g2, c3]))
lh &= seq(parn([af0, af1]), parn([df0, df1]), parn([g0, g1]), parn([c0, c1]))

# mm 13
rh &= parn([c3, ef3, g3, c4], 4)
lh &= parn([c2, g2], 4)

final = rh | lh
# Not all applications agree on where to begin numbering pitches. Uncomment the
# following line if it is heard an octave too low.
final.transpose(12)
end

SMFWriter.new(:tempo => 40).
  track(score, :name => 'Op. 20, No. 2').
  save('chopin-op28-no20')

