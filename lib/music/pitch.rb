module Music
  class Pitch
    attr_reader :pc, :oct
    
    def initialize(pc, oct)
      @pc, @oct = pc, oct
    end
    
    def to_i; @pc.to_i + @oct * 12 end
    def to_s; "#@pc#@oct" end
    alias inspect to_s
  end
  
  class PitchClass
    include Comparable
    
    def self.from_integer(i)
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
    
    attr_reader :name, :rank
    alias natural_rank rank
    alias to_i rank
    
    def initialize(name, rank)
      @name, @rank = name, rank
    end
    
    def <=>(pc)
      [rank, natural_rank] <=> [pc.rank, pc.natural_rank]
    end
    
    def to_s; name.to_s end
    alias inspect to_s
    
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
  
  class Accidental
    include Comparable
    attr_reader :pc
    
    def initialize(pc)
      @pc = pc
    end
    
    def <=>(other)
      [rank, natural_rank] <=> [other.rank, other.natural_rank]
    end
    
    def natural_rank; @pc.rank end
    
    def to_i; rank end
    
    def inspect; to_s end
  end
  
  class Sharp < Accidental
    def rank; @pc.rank + 1 end
    
    def to_s; "#{@pc}s" end
  end
  
  class Flat < Accidental
    def rank; @pc.rank - 1 end
    
    def to_s; "#{@pc}f" end
  end
  
  module_function
  def sharp(p)
    case p
      when Pitch
        Pitch.new(sharp(p.pc), p.oct)
      when PitchClass
        Sharp.new(p)
    end
  end
  
  def flat(p)
    case p
      when Pitch
        Pitch.new(flat(p.pc), p.oct)
      when PitchClass
        Flat.new(p)
    end
  end
  
  ## PitchClass constructors
  
  def cf; flat(c) end
  def c; PitchClass.new('c', 0) end
  def cs; sharp(c) end
  def df; flat(d) end
  def d; PitchClass.new('d', 2) end
  def ds; sharp(d) end
  def ef; flat(e) end
  def e; PitchClass.new('e', 4) end
  def es; sharp(e) end
  def ff; flat(f) end
  def f; PitchClass.new('f', 5) end
  def fs; sharp(f) end
  def gf; flat(g) end
  def g; PitchClass.new('g', 7) end
  def gs; sharp(g) end
  def af; flat(a) end
  def a; PitchClass.new('a', 9) end
  def as; sharp(a) end
  def bf; flat(b) end
  def b; PitchClass.new('b', 11) end
  def bs; sharp(b) end
end
