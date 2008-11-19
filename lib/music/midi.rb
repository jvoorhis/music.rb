require 'music/midi/smf_writer'

module Music
  module MIDI
    
    module_function
    # Create a tempo change.
    def tempo(bpm)
      ctl(:tempo, :tempo => bpm)
    end

    # Standard midi control changes
    def cc1(value)
      ctl(:cc1, :value => value)
    end
    
    def cc2(value)
      ctl(:cc2, :value => value)
    end
    
    def cc3(value)
      ctl(:cc3, :value => value)
    end
    
    def cc4(value)
      ctl(:cc4, :value => value)
    end
    
    def cc5(value)
      ctl(:cc5, :value => value)
    end
    
    def cc6(value)
      ctl(:cc6, :value => value)
    end
    
    def cc7(value)
      ctl(:cc7, :value => value)
    end
    
    def cc8(value)
      ctl(:cc8, :value => value)
    end
    
    def cc9(value)
      ctl(:cc9, :value => value)
    end
    
    def cc10(value)
      ctl(:cc10, :value => value)
    end
    
    def cc11(value)
      ctl(:cc11, :value => value)
    end
    
    def cc12(value)
      ctl(:cc12, :value => value)
    end
    
    def cc13(value)
      ctl(:cc13, :value => value)
    end
    
    def cc14(value)
      ctl(:cc14, :value => value)
    end
    
    def cc15(value)
      ctl(:cc15, :value => value)
    end
    
    def cc16(value)
      ctl(:cc16, :value => value)
    end
  end
end
