require 'music/midi/midi_time'
require 'music/midi/smf_writer'

module Music
  module MIDI
    
    module_function
    # Create a tempo change.
    def tempo(bpm)
      ctl(:tempo, :tempo => bpm)
    end
    
    # Standard midi control changes
    def cc1(value, attrs = {})      
      ctl(:cc1, attrs.merge(:value => value))
    end
    
    def cc2(value, attrs = {})      
      ctl(:cc2, attrs.merge(:value => value))
    end
    
    def cc3(value, attrs = {})      
      ctl(:cc3, attrs.merge(:value => value))
    end
    
    def cc4(value, attrs = {})      
      ctl(:cc4, attrs.merge(:value => value))
    end
    
    def cc5(value, attrs = {})      
      ctl(:cc5, attrs.merge(:value => value))
    end
    
    def cc6(value, attrs = {})      
      ctl(:cc6, attrs.merge(:value => value))
    end
    
    def cc7(value, attrs = {})      
      ctl(:cc7, attrs.merge(:value => value))
    end
    
    def cc8(value, attrs = {})      
      ctl(:cc8, attrs.merge(:value => value))
    end
    
    def cc9(value, attrs = {})      
      ctl(:cc9, attrs.merge(:value => value))
    end
    
    def cc10(value, attrs = {})      
      ctl(:cc10, attrs.merge(:value => value))
    end
    
    def cc11(value, attrs = {})      
      ctl(:cc11, attrs.merge(:value => value))
    end
    
    def cc12(value, attrs = {})      
      ctl(:cc12, attrs.merge(:value => value))
    end
    
    def cc13(value, attrs = {})      
      ctl(:cc13, attrs.merge(:value => value))
    end
    
    def cc14(value, attrs = {})      
      ctl(:cc14, attrs.merge(:value => value))
    end
    
    def cc15(value, attrs = {})      
      ctl(:cc15, attrs.merge(:value => value))
    end
    
    def cc16(value, attrs = {})      
      ctl(:cc16, attrs.merge(:value => value))
    end
  end
end
