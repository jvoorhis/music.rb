module Music
  class Key
    def initialize(pcs)
      @pcs = pcs
    end
    
    def include?(p)
      @pcs.include?(p.pc)
    end
    
    def transpose(p, deg)
      pol  = deg ** 0 # polarity
      
      oct1 = p.oct
      pc1  = p.pc
      k1   = @pcs.detect { |pc| pc.kernel == pc1.kernel }
      i1   = @pcs.index(k1)
      
      i2   = (i1 + deg) % @pcs.size * pol
      k2   = @pcs[i2]
      pc2  = k2.acc(pc1.acc_i - k1.acc_i)
      oct2 = oct1 + (deg/@pcs.size) * pol
      Pitch.new(pc2, oct2)
    end
  end
end
