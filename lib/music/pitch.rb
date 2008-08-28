module Music  
  class Pitch
    include Comparable
    
    attr_reader :pitch_class, :octave
    
    def initialize(pc, oct)
      @pitch_class, @octave = pc, oct
    end
    
    def <=>(p) [oct, pc] <=> [p.oct, p.pc] end
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
  
  class Scale
    def self.[](*degrees) new(degrees) end
    
    def initialize(degrees)
      @degrees = degrees.sort.uniq
    end
    
    def size; @degrees.size end
    
    def member?(pitch)
      @degrees.include?(pitch % 12)
    end
    
    def transpose(pitch, interval)
      unless member?(pitch)
        return transpose(pitch - 1, interval) + 1
      end
      
      oct1, pc1 = pitch.divmod(12)
      i1 = @degrees.index(pc1)
      wrap, i2 = (i1 + interval).divmod(@degrees.size)
      pc2 = @degrees[i2]
      
      if (((_p = pc2 + (oct1 + wrap) * 12) - pitch) > 0) ^ (interval <= 0)
        _p
      else
        pc2 + ((oct1 + 1) * 12)
      end
    end
  end
end
