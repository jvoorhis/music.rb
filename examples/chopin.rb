# Encoding of Chopin's Op. 28, No 20.
# 'Funeral March'
# Transcribed from http://www.mutopiaproject.org/ftp/ChopinFF/O28/Chop-28-20/Chop-28-20-let.pdf

require 'music'

include Music

# Redefine chord to take a list of pitches to a chord of duration QN
def chord(*ps)
  attrs = ps.last.is_a?(Hash) ? ps.pop : {}
  dur   = attrs.delete(:duration) || attrs.delete(:dur) || QN
  ps.map { |p| note(p, dur, attrs) }.inject { |a,b| a | b }
end
alias ch chord

def score
# mm 1
rh = ch(g2, c3, ef3, g3) & ch(af2, c3, ef3, af3) & (ch(g2, b2) | ch(ef3, g3, :dur => DEN) & ch(d3, f3, :dur => SN)) & ch(ef2, g2, c3, ef3)
lh = ch(c1, c2) & ch(f0, f1) & ch(g0, g1) & ch(c1, g1, c2)

# mm 2
rh &= ch(ef2, af2, c3, ef3) & ch(f2, af2, df3, f3) & (ch(df2, ef2, g2) | ch(c3, ef3, :dur => DEN) & ch(bf2, df3, :dur => SN)) & ch(c2, ef2, g2, c3)
lh &= ch(af1, af2) & ch(df1, df2) & ch(ef1, ef2) & ch(af1, af2)

# mm 3
rh &= ch(d2, f2, b2, d3) & ch(e2, g2, bf2, c3, e3) & (ch(af2, c3) | note(g3, DEN) & note(f3, SN)) & ch(g2, c3, ef3)
lh &= ch(g1, g2) & ch(c0, c1) & ch(f0, f1) & ch(c1, c2)

# mm 4
rh &= ch(fs2, c3, d3) & ch(g2, b2, d3, g3) & (ch(c3, d3, fs3) | note(b3, DEN) & note(a3, SN)) & ch(bf2, d3, g3)
lh &= ch(d1, a1, d2) & ch(g0, g1) & ch(d0, d1) & ch(g0, g1)

# mm 5
rh &= ch(ef3, g3, ef4) & ch(ef3, af3, ef4) & (ch(d3, d4) | note(af3, DEN) & note(fs3, SN)) & ch(d3, af3, d4)
lh &= ch(c1, c2) & ch(c2, c3) & ch(b1, b2) & ch(bf1, bf2)

# mm 6
rh &= ch(c3, g3, c4) & ch(c3, d3, fs3, d4) & (ch(d3, g3, b3, :dur => DEN) & ch(c3, a3, :dur => SN)) & ch(b2, d3, g3)
lh &= ch(a1, a2) & ch(af1, af2) & ch(g1, g2) & ch(f1, f2)

# mm 7
rh &= ch(c3, g3, c4) & ch(af2, c3, af3) & (ch(g2, d3) | note(g3, DEN) & note(f3, SN)) & ch(g2, c3, ef3)
lh &= ch(ef1, ef2) & ch(f1, f2) & ch(b0, b1) & ch(c1, c2)

# mm 8
rh &= ch(ef2, af2, c3, ef3) & ch(f2, af2, df3, f3) & (ch(f2, g2, b2) | note(ef3, DEN) & note(d3, SN)) & ch(ef2, g2, c3)
lh &= ch(af0, af1) & ch(df0, df1) & ch(g0, g1) & ch(c0, c1)

# mm 9
rh &= ch(ef3, g3, ef4) & ch(ef3, af3, ef3) & (ch(d3, d4) | note(af3, DEN) & note(fs3, SN)) & ch(d3, g3, d4)
lh &= ch(c1, c2) & ch(c2, c3) & ch(b1, b2) & ch(bf1, bf2)

# mm 10
rh &= ch(c3, g3, c4) & ch(c3, d3, fs3, d4) & (ch(d3, g3, b3, :dur => DEN) & ch(c3, a3, :dur => SN)) & ch(b2, d3, g3)
lh &= ch(a1, a2) & ch(af1, af2) & ch(g1, g2) & ch(f1, f2)

# mm 11
rh &= ch(c3, g3, c4) & ch(af2, c3, af3) & (ch(g2, d3) | note(g3, DEN) & note(f3, SN)) & ch(g2, c3, ef3)
lh &= ch(ef1, ef2) & ch(f1, f2) & ch(b0, b1) & ch(c1, c2)

# mm 12
rh &= ch(ef2, af2, c3, ef3) & ch(f2, af2, df3, f3) & (ch(f2, g2, b2) | note(ef3, DEN) & note(d3, SN)) & ch(ef2, g2, c3)
lh &= ch(af0, af1) & ch(df0, df1) & ch(g0, g1) & ch(c0, c1)

# mm 13
rh &= ch(c3, ef3, g3, c4, :dur => 4)
lh &= ch(c2, g2, :dur => 4)

score = rh | lh
# Not all applications agree on where to begin numbering pitches. Uncomment the
# following line if it is heard an octave too low.
# score = (rh | lh).transpose(12)
end

SMFWriter.new(:tempo => 80).
  track(score, :name => 'Op. 20, No. 2').
  save('chopin-op28-no20')
