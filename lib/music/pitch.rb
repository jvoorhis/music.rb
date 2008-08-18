module Music  
  class Pitch
    attr_reader :pitch_class, :octave
    def initialize(pc, oct)
      @pitch_class, @octave = pc, oct
    end
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
end
