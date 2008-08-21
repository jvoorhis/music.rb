# Encoding of Chopin's Op. 28, No 20.
# 'Funeral March'
# Transcribed from http://www.mutopiaproject.org/ftp/ChopinFF/O28/Chop-28-20/Chop-28-20-let.pdf

require 'music'
require 'music/abs_pitch'
include Music
include AbsPitch

# Redefine chord to take a list of pitches to a chord of duration QN
def chord(*ps)
  attrs = ps.last.is_a?(Hash) ? ps.pop : {}
  dur   = attrs.delete(:duration) || attrs.delete(:dur) || QN
  ps.map { |p| note(p, dur, attrs) }.inject { |a,b| a | b }
end
alias ch chord

# mm 1
rh = ch(G2, C3, EF3, G3) & ch(AF2, C3, EF3, AF3) & (ch(G2, B2) | ch(EF3, G3, :dur => DEN) & ch(D3, F3, :dur => SN)) & ch(EF2, G2, C3, EF3)
lh = ch(C1, C2) & ch(F0, F1) & ch(G0, G1) & ch(C1, G1, C2)

# mm 2
rh &= ch(EF2, AF2, C3, EF3) & ch(F2, AF2, C3, EF3) & (ch(DF2, EF2, G2) | ch(C3, EF3, :dur => DEN) & ch(BF2, DF3, :dur => SN)) & ch(C2, EF2, G2, C3)
lh &= ch(AF1, AF2) & ch(DF1, DF2) & ch(EF1, EF2) & ch(AF1, AF2)

# mm 3
rh &= ch(D2, F2, B2, D3) & ch(E2, G2, BF2, C3, E3) & (ch(AF2, C3) | note(G3, DEN) & note(F3, SN)) & ch(G2, C3, EF3)
lh &= ch(G1, G2) & ch(C0, C1) & ch(F0, F1) & ch(C1, C2)

# mm 4
rh &= ch(FS2, C3, D3) & ch(G2, B2, D3, G3) & (ch(C3, D3, FS3) | note(B3, DEN) & note(A3, SN)) & ch(BF2, D3, G3)
lh &= ch(D1, A1, D2) & ch(G0, G1) & ch(D0, D1) & ch(G0, G1)

# mm 5
rh &= ch(EF3, G3, EF4) & ch(EF3, AF3, EF4) & (ch(D3, D4) | note(AF3, DEN) & note(FS3, SN)) & ch(D3, AF3, D4)
lh &= ch(C1, C2) & ch(C2, C3) & ch(B1, B2) & ch(BF1, BF2)

# mm 6
rh &= ch(C3, G3, C4) & ch(C3, D3, FS3, D4) & (ch(D3, G3, B3, :dur => DEN) & ch(C3, A3, :dur => SN)) & ch(B2, D3, G3)
lh &= ch(A1, A2) & ch(AF1, AF2) & ch(G1, G2) & ch(F1, F2)

# mm 7
rh &= ch(C3, G3, C4) & ch(AF2, C3, AF3) & (ch(G2, D3) | note(G3, DEN) & note(F3, SN)) & ch(G2, C3, EF3)
lh &= ch(EF1, EF2) & ch(F1, F2) & ch(B0, B1) & ch(C1, C2)

# mm 8
rh &= ch(EF2, AF2, C3, EF3) & ch(F2, AF2, DF3, F3) & (ch(F2, G2, B2) | note(EF3, DEN) & note(D3, SN)) & ch(EF2, G2, C3)
lh &= ch(AF0, AF1) & ch(DF0, DF1) & ch(G0, G1) & ch(C0, C1)

# mm 9
rh &= ch(EF3, G3, EF4) & ch(EF3, AF3, EF3) & (ch(D3, D4) | note(AF3, DEN) & note(FS3, SN)) & ch(D3, G3, D4)
lh &= ch(C1, C2) & ch(C2, C3) & ch(B1, B2) & ch(BF1, BF2)

# mm 10
rh &= ch(C3, G3, C4) & ch(C3, D3, FS3, D4) & (ch(D3, G3, B3, :dur => DEN) & ch(C3, A3, :dur => SN)) & ch(B2, D3, G3)
lh &= ch(A1, A2) & ch(AF1, AF2) & ch(G1, G2) & ch(F1, F2)

# mm 11
rh &= ch(C3, G3, C4) & ch(AF2, C3, AF3) & (ch(G2, D3) | note(G3, DEN) & note(F3, SN)) & ch(G2, C3, EF3)
lh &= ch(EF1, EF2) & ch(F1, F2) & ch(B0, B1) & ch(C1, C2)

# mm 12
rh &= ch(EF2, AF2, C3, EF3) & ch(F2, AF2, DF3, F3) & (ch(F2, G2, B2) | note(EF3, DEN) & note(D3, SN)) & ch(EF2, G2, C3)
lh &= ch(AF0, AF1) & ch(DF0, DF1) & ch(G0, G1) & ch(C0, C1)

# mm 13
rh &= ch(C3, EF3, G3, C4, :dur => 4)
lh &= ch(C2, G2, :dur => 4)

score = (rh | lh)
# Not all applications agree on where to begin numbering pitches. Uncomment the
# following line if it is heard an octave too low.
# score = (rh | lh).transpose(12)

SMFWriter.new(:tempo => 80).
  track(score, :name => 'Op. 20, No. 2').
  save('chopin-op28-no20')
