module Music
  class Pitch
    include Comparable
    attr_reader :pc, :oct
    
    def self.from_midi(i)
      pc  = PitchClass.from_integer(i)
      oct = i.div(12) - 1
      new(pc, oct)
    end
    class << self; alias from_integer from_midi end
    
    def self.from_hz(hz)
      from_integer(ftom(hz))
    end
    class << self; alias from_float from_hz end
    
    def initialize(pc, oct)
      @pc, @oct = pc, oct
    end
    
    def +(n)
      pc1  = pc + n
      oct1 = (to_i + n).div(12) + if (pc1 > pc) ^ !(n > 0)
                                    -1
                                  else
                                    -n ** 0
                                  end
      Pitch.new(pc1, oct1)
    end
    
    def -(n) self + -n end
    
    def *(n) self.class.from_hz(self.to_hz * n) end
    
    def /(n) self * 1.quo(n) end
    
    def %(pitch) to_f / pitch.to_f end
    
    def <=>(pitch)
      [to_i, oct, pc] <=> [pitch.to_i, pitch.oct, pitch.pc]
    end
    
    def eql?(pitch)
      (self <=> pitch) == 0
    end
    
    def hash
      [oct, pc].hash
    end
    
    def to_midi
      pc.to_i + (oct + 1) * 12
    end
    alias to_i to_midi
    
    def to_hz
      440.0 * (2.0 ** ((to_i.to_f-69)/12))
    end
    alias to_f to_hz
    
    def sharp; Pitch.new(Sharp.new(pc), oct) end
    
    def flat; Pitch.new(Flat.new(pc), oct) end
    
    def to_s; pc.to_s + oct.to_s end
    alias inspect to_s
  end
  
  class PitchClass
    include Comparable
    
    def self.from_midi(i)
      case i % 12
        when 0: c
        when 1: cs
        when 2: d
        when 3: ds
        when 4: e
        when 5: f
        when 6: fs
        when 7: g
        when 8: gs
        when 9: a
        when 10: as
        when 11: b
      end
    end
    class << self; alias from_integer from_midi end
    
    attr_reader :name, :rank
    alias natural_rank rank
    alias to_i rank
    
    def initialize(name, rank)
      @name, @rank = name, rank
    end
    
    def +(n) self.class.from_integer(to_i + n) end
    
    def -(n) self + -n end
    
    def <=>(pc)
      [rank, natural_rank] <=> [pc.rank, pc.natural_rank]
    end
    
    def eql?(pc)
      (self <=> pc) == 0
    end
    
    def hash
      [self.class.name, rank, natural_rank].hash
    end
    
    def sharp; Sharp.new(self) end
    
    def flat; Flat.new(self) end
    
    def to_s; name.to_s end
    alias inspect to_s
  end
  
  class Accidental
    include Comparable
    attr_reader :pc
    
    def initialize(pc)
      @pc = pc
    end
    
    def +(n)
      self.class.new(pc + n)
    end
    
    def -(n) self + -n end
    
    def <=>(other)
      [rank, natural_rank] <=> [other.rank, other.natural_rank]
    end
    
    def eql?(pc)
      (self <=> pc) == 0
    end
    
    def hash
      [self.class.name, pc].hash
    end
    
    def natural_rank; pc.rank end
    
    def to_i; rank end
    
    def sharp; Sharp.new(self) end
    
    def flat; Flat.new(self) end
    
    def inspect; to_s end
  end
  
  class Sharp < Accidental    
    def rank; pc.rank + 1 end
    
    def to_s; "#{pc}s" end
  end
  
  class Flat < Accidental
    def rank; pc.rank - 1 end
    
    def to_s; "#{pc}f" end
  end
  
  module_function
  
  ## Pitch Class constructors
  
  def cf; Flat.new(c) end
  def c; PitchClass.new('c', 0) end
  def cs; Sharp.new(c) end
  def df; Flat.new(d) end
  def d; PitchClass.new('d', 2) end
  def ds; Sharp.new(d) end
  def ef; Flat.new(e) end
  def e; PitchClass.new('e', 4) end
  def es; Sharp.new(e) end
  def ff; Flat.new(f) end
  def f; PitchClass.new('f', 5) end
  def fs; Sharp.new(f) end
  def gf; Flat.new(g) end
  def g; PitchClass.new('g', 7) end
  def gs; Sharp.new(g) end
  def af; Flat.new(a) end
  def a; PitchClass.new('a', 9) end
  def as; Sharp.new(a) end
  def bf; Flat.new(b) end
  def b; PitchClass.new('b', 11) end
  def bs; Sharp.new(b) end
  
  ## Pitch Constructors
  
  def c_1; Pitch.new(c, -1) end
  def cs_1; Pitch.new(cs, -1) end
  def df_1; Pitch.new(df, -1) end
  def d_1; Pitch.new(d, -1) end
  def ds_1; Pitch.new(ds, -1) end
  def ef_1; Pitch.new(ef, -1) end
  def e_1; Pitch.new(e, -1) end
  def es_1; Pitch.new(es, -1) end
  def ff_1; Pitch.new(ff, -1) end
  def f_1; Pitch.new(f, -1) end
  def fs_1; Pitch.new(fs, -1) end
  def gf_1; Pitch.new(gf, -1) end
  def g_1; Pitch.new(g, -1) end
  def gs_1; Pitch.new(gs, -1) end
  def af_1; Pitch.new(af, -1) end
  def a_1; Pitch.new(a, -1) end
  def as_1; Pitch.new(as, -1) end
  def bf_1; Pitch.new(bf, -1) end
  def b_1; Pitch.new(b, -1) end
  def bs_1; Pitch.new(bs, -1) end
  def cf0; Pitch.new(cf, 0) end
  def c0; Pitch.new(c, 0) end
  def cs0; Pitch.new(cs, 0) end
  def df0; Pitch.new(df, 0) end
  def d0; Pitch.new(d, 0) end
  def ds0; Pitch.new(ds, 0) end
  def ef0; Pitch.new(ef, 0) end
  def e0; Pitch.new(e, 0) end
  def es0; Pitch.new(es, 0) end
  def ff0; Pitch.new(ff, 0) end
  def f0; Pitch.new(f, 0) end
  def fs0; Pitch.new(fs, 0) end
  def gf0; Pitch.new(gf, 0) end
  def g0; Pitch.new(g, 0) end
  def gs0; Pitch.new(gs, 0) end
  def af0; Pitch.new(af, 0) end
  def a0; Pitch.new(a, 0) end
  def as0; Pitch.new(as, 0) end
  def bf0; Pitch.new(bf, 0) end
  def b0; Pitch.new(b, 0) end
  def bs0; Pitch.new(bs, 0) end
  def cf1; Pitch.new(cf, 1) end
  def c1; Pitch.new(c, 1) end
  def cs1; Pitch.new(cs, 1) end
  def df1; Pitch.new(df, 1) end
  def d1; Pitch.new(d, 1) end
  def ds1; Pitch.new(ds, 1) end
  def ef1; Pitch.new(ef, 1) end
  def e1; Pitch.new(e, 1) end
  def es1; Pitch.new(es, 1) end
  def ff1; Pitch.new(ff, 1) end
  def f1; Pitch.new(f, 1) end
  def fs1; Pitch.new(fs, 1) end
  def gf1; Pitch.new(gf, 1) end
  def g1; Pitch.new(g, 1) end
  def gs1; Pitch.new(gs, 1) end
  def af1; Pitch.new(af, 1) end
  def a1; Pitch.new(a, 1) end
  def as1; Pitch.new(as, 1) end
  def bf1; Pitch.new(bf, 1) end
  def b1; Pitch.new(b, 1) end
  def bs1; Pitch.new(bs, 1) end
  def cf2; Pitch.new(cf, 2) end
  def c2; Pitch.new(c, 2) end
  def cs2; Pitch.new(cs, 2) end
  def df2; Pitch.new(df, 2) end
  def d2; Pitch.new(d, 2) end
  def ds2; Pitch.new(ds, 2) end
  def ef2; Pitch.new(ef, 2) end
  def e2; Pitch.new(e, 2) end
  def es2; Pitch.new(es, 2) end
  def ff2; Pitch.new(ff, 2) end
  def f2; Pitch.new(f, 2) end
  def fs2; Pitch.new(fs, 2) end
  def gf2; Pitch.new(gf, 2) end
  def g2; Pitch.new(g, 2) end
  def gs2; Pitch.new(gs, 2) end
  def af2; Pitch.new(af, 2) end
  def a2; Pitch.new(a, 2) end
  def as2; Pitch.new(as, 2) end
  def bf2; Pitch.new(bf, 2) end
  def b2; Pitch.new(b, 2) end
  def bs2; Pitch.new(bs, 2) end
  def cf3; Pitch.new(cf, 3) end
  def c3; Pitch.new(c, 3) end
  def cs3; Pitch.new(cs, 3) end
  def df3; Pitch.new(df, 3) end
  def d3; Pitch.new(d, 3) end
  def ds3; Pitch.new(ds, 3) end
  def ef3; Pitch.new(ef, 3) end
  def e3; Pitch.new(e, 3) end
  def es3; Pitch.new(es, 3) end
  def ff3; Pitch.new(ff, 3) end
  def f3; Pitch.new(f, 3) end
  def fs3; Pitch.new(fs, 3) end
  def gf3; Pitch.new(gf, 3) end
  def g3; Pitch.new(g, 3) end
  def gs3; Pitch.new(gs, 3) end
  def af3; Pitch.new(af, 3) end
  def a3; Pitch.new(a, 3) end
  def as3; Pitch.new(as, 3) end
  def bf3; Pitch.new(bf, 3) end
  def b3; Pitch.new(b, 3) end
  def bs3; Pitch.new(bs, 3) end
  def cf4; Pitch.new(cf, 4) end
  def c4; Pitch.new(c, 4) end
  def cs4; Pitch.new(cs, 4) end
  def df4; Pitch.new(df, 4) end
  def d4; Pitch.new(d, 4) end
  def ds4; Pitch.new(ds, 4) end
  def ef4; Pitch.new(ef, 4) end
  def e4; Pitch.new(e, 4) end
  def es4; Pitch.new(es, 4) end
  def ff4; Pitch.new(ff, 4) end
  def f4; Pitch.new(f, 4) end
  def fs4; Pitch.new(fs, 4) end
  def gf4; Pitch.new(gf, 4) end
  def g4; Pitch.new(g, 4) end
  def gs4; Pitch.new(gs, 4) end
  def af4; Pitch.new(af, 4) end
  def a4; Pitch.new(a, 4) end
  def as4; Pitch.new(as, 4) end
  def bf4; Pitch.new(bf, 4) end
  def b4; Pitch.new(b, 4) end
  def bs4; Pitch.new(bs, 4) end
  def cf5; Pitch.new(cf, 5) end
  def c5; Pitch.new(c, 5) end
  def cs5; Pitch.new(cs, 5) end
  def df5; Pitch.new(df, 5) end
  def d5; Pitch.new(d, 5) end
  def ds5; Pitch.new(ds, 5) end
  def ef5; Pitch.new(ef, 5) end
  def e5; Pitch.new(e, 5) end
  def es5; Pitch.new(es, 5) end
  def ff5; Pitch.new(ff, 5) end
  def f5; Pitch.new(f, 5) end
  def fs5; Pitch.new(fs, 5) end
  def gf5; Pitch.new(gf, 5) end
  def g5; Pitch.new(g, 5) end
  def gs5; Pitch.new(gs, 5) end
  def af5; Pitch.new(af, 5) end
  def a5; Pitch.new(a, 5) end
  def as5; Pitch.new(as, 5) end
  def bf5; Pitch.new(bf, 5) end
  def b5; Pitch.new(b, 5) end
  def bs5; Pitch.new(bs, 5) end
  def cf6; Pitch.new(cf, 6) end
  def c6; Pitch.new(c, 6) end
  def cs6; Pitch.new(cs, 6) end
  def df6; Pitch.new(df, 6) end
  def d6; Pitch.new(d, 6) end
  def ds6; Pitch.new(ds, 6) end
  def ef6; Pitch.new(ef, 6) end
  def e6; Pitch.new(e, 6) end
  def es6; Pitch.new(es, 6) end
  def ff6; Pitch.new(ff, 6) end
  def f6; Pitch.new(f, 6) end
  def fs6; Pitch.new(fs, 6) end
  def gf6; Pitch.new(gf, 6) end
  def g6; Pitch.new(g, 6) end
  def gs6; Pitch.new(gs, 6) end
  def af6; Pitch.new(af, 6) end
  def a6; Pitch.new(a, 6) end
  def as6; Pitch.new(as, 6) end
  def bf6; Pitch.new(bf, 6) end
  def b6; Pitch.new(b, 6) end
  def bs6; Pitch.new(bs, 6) end
  def cf7; Pitch.new(cf, 7) end
  def c7; Pitch.new(c, 7) end
  def cs7; Pitch.new(cs, 7) end
  def df7; Pitch.new(df, 7) end
  def d7; Pitch.new(d, 7) end
  def ds7; Pitch.new(ds, 7) end
  def ef7; Pitch.new(ef, 7) end
  def e7; Pitch.new(e, 7) end
  def es7; Pitch.new(es, 7) end
  def ff7; Pitch.new(ff, 7) end
  def f7; Pitch.new(f, 7) end
  def fs7; Pitch.new(fs, 7) end
  def gf7; Pitch.new(gf, 7) end
  def g7; Pitch.new(g, 7) end
  def gs7; Pitch.new(gs, 7) end
  def af7; Pitch.new(af, 7) end
  def a7; Pitch.new(a, 7) end
  def as7; Pitch.new(as, 7) end
  def bf7; Pitch.new(bf, 7) end
  def b7; Pitch.new(b, 7) end
  def bs7; Pitch.new(bs, 7) end
  def cf8; Pitch.new(cf, 8) end
  def c8; Pitch.new(c, 8) end
  def cs8; Pitch.new(cs, 8) end
  def df8; Pitch.new(df, 8) end
  def d8; Pitch.new(d, 8) end
  def ds8; Pitch.new(ds, 8) end
  def ef8; Pitch.new(ef, 8) end
  def e8; Pitch.new(e, 8) end
  def es8; Pitch.new(es, 8) end
  def ff8; Pitch.new(ff, 8) end
  def f8; Pitch.new(f, 8) end
  def fs8; Pitch.new(fs, 8) end
  def gf8; Pitch.new(gf, 8) end
  def g8; Pitch.new(g, 8) end
  def gs8; Pitch.new(gs, 8) end
  def af8; Pitch.new(af, 8) end
  def a8; Pitch.new(a, 8) end
  def as8; Pitch.new(as, 8) end
  def bf8; Pitch.new(bf, 8) end
  def b8; Pitch.new(b, 8) end
  def bs8; Pitch.new(bs, 8) end
  def cf9; Pitch.new(cf, 9) end
  def c9; Pitch.new(c, 9) end
  def cs9; Pitch.new(cs, 9) end
  def df9; Pitch.new(df, 9) end
  def d9; Pitch.new(d, 9) end
  def ds9; Pitch.new(ds, 9) end
  def ef9; Pitch.new(ef, 9) end
  def e9; Pitch.new(e, 9) end
  def es9; Pitch.new(es, 9) end
  def ff9; Pitch.new(ff, 9) end
  def f9; Pitch.new(f, 9) end
  def fs9; Pitch.new(fs, 9) end
  def gf9; Pitch.new(gf, 9) end
  def g9; Pitch.new(g, 9) end
end
