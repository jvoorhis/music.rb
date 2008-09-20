module Music
  class Key
    def initialize(pcs)
      @pcs = pcs
    end
    
    def include?(p)
      @pcs.include?(p.pc)
    end
    
    def transpose(p, deg)
      # This algorithm resolves the given pitch to a member pitch by
      # comparing their kernels, determining which accidentals were applied to
      # the pitch, transposing the resolved pitch by the specified degrees, and
      # applying the same accidentals to the transposed member pitch.
      pol  = deg ** 0 # polarity of the transposition
      
      oct1 = p.oct
      pc1  = p.pc
      mpc1 = @pcs.detect { |pc| pc.kernel == p.pc.kernel } # member pitch class
      i1   = @pcs.index(mpc1)
      
      i2   = ((i1 + deg) % @pcs.size) * pol
      mpc2 = @pcs[i2]
      acc  = pc1.acc_i - mpc1.acc_i
      pc2  = mpc2.acc(acc)
      oct2 = (oct1 + (deg / @pcs.size)) * pol
      Pitch.new(pc2, oct2)
    end
  end
end
