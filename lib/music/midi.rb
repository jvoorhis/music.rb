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
    def cc0(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 0, :value => value))
    end
    
    def cc1(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 1, :value => value))
    end
    
    def cc2(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 2, :value => value))
    end
    
    def cc3(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 3, :value => value))
    end
    
    def cc4(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 4, :value => value))
    end
    
    def cc5(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 5, :value => value))
    end
    
    def cc6(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 6, :value => value))
    end
    
    def cc7(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 7, :value => value))
    end
    
    def cc8(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 8, :value => value))
    end
    
    def cc9(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 9, :value => value))
    end
    
    def cc10(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 10, :value => value))
    end
    
    def cc11(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 11, :value => value))
    end
    
    def cc12(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 12, :value => value))
    end
    
    def cc13(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 13, :value => value))
    end
    
    def cc14(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 14, :value => value))
    end
    
    def cc15(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 15, :value => value))
    end
    
    def cc16(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 16, :value => value))
    end

    def cc17(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 17, :value => value))
    end

    def cc18(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 18, :value => value))
    end

    def cc19(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 19, :value => value))
    end

    def cc20(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 20, :value => value))
    end

    def cc21(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 21, :value => value))
    end

    def cc22(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 22, :value => value))
    end

    def cc23(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 23, :value => value))
    end

    def cc24(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 24, :value => value))
    end

    def cc25(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 25, :value => value))
    end

    def cc26(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 26, :value => value))
    end

    def cc27(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 27, :value => value))
    end

    def cc28(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 28, :value => value))
    end

    def cc29(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 29, :value => value))
    end

    def cc30(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 30, :value => value))
    end

    def cc31(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 31, :value => value))
    end

    def cc32(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 32, :value => value))
    end

    def cc33(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 33, :value => value))
    end

    def cc34(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 34, :value => value))
    end

    def cc35(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 35, :value => value))
    end

    def cc36(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 36, :value => value))
    end

    def cc37(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 37, :value => value))
    end

    def cc38(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 38, :value => value))
    end

    def cc39(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 39, :value => value))
    end

    def cc40(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 40, :value => value))
    end

    def cc41(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 41, :value => value))
    end

    def cc42(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 42, :value => value))
    end

    def cc43(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 43, :value => value))
    end

    def cc44(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 44, :value => value))
    end

    def cc45(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 45, :value => value))
    end

    def cc46(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 46, :value => value))
    end

    def cc47(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 47, :value => value))
    end

    def cc48(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 48, :value => value))
    end

    def cc49(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 49, :value => value))
    end

    def cc50(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 50, :value => value))
    end

    def cc51(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 51, :value => value))
    end

    def cc52(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 52, :value => value))
    end

    def cc53(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 53, :value => value))
    end

    def cc54(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 54, :value => value))
    end

    def cc55(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 55, :value => value))
    end

    def cc56(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 56, :value => value))
    end

    def cc57(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 57, :value => value))
    end

    def cc58(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 58, :value => value))
    end

    def cc59(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 59, :value => value))
    end

    def cc60(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 60, :value => value))
    end

    def cc61(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 61, :value => value))
    end

    def cc62(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 62, :value => value))
    end

    def cc63(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 63, :value => value))
    end

    def cc64(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 64, :value => value))
    end

    def cc65(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 65, :value => value))
    end

    def cc66(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 66, :value => value))
    end

    def cc67(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 67, :value => value))
    end

    def cc68(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 68, :value => value))
    end

    def cc69(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 69, :value => value))
    end

    def cc70(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 70, :value => value))
    end

    def cc71(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 71, :value => value))
    end

    def cc72(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 72, :value => value))
    end

    def cc73(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 73, :value => value))
    end

    def cc74(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 74, :value => value))
    end

    def cc75(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 75, :value => value))
    end

    def cc76(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 76, :value => value))
    end

    def cc77(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 77, :value => value))
    end

    def cc78(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 78, :value => value))
    end

    def cc79(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 79, :value => value))
    end

    def cc80(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 80, :value => value))
    end

    def cc81(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 81, :value => value))
    end

    def cc82(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 82, :value => value))
    end

    def cc83(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 83, :value => value))
    end

    def cc84(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 84, :value => value))
    end

    def cc85(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 85, :value => value))
    end

    def cc86(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 86, :value => value))
    end

    def cc87(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 87, :value => value))
    end

    def cc88(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 88, :value => value))
    end

    def cc89(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 89, :value => value))
    end

    def cc90(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 90, :value => value))
    end

    def cc91(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 91, :value => value))
    end

    def cc92(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 92, :value => value))
    end

    def cc93(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 93, :value => value))
    end

    def cc94(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 94, :value => value))
    end

    def cc95(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 95, :value => value))
    end

    def cc96(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 96, :value => value))
    end

    def cc97(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 97, :value => value))
    end

    def cc98(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 98, :value => value))
    end

    def cc99(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 99, :value => value))
    end

    def cc100(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 100, :value => value))
    end

    def cc101(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 101, :value => value))
    end

    def cc102(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 102, :value => value))
    end

    def cc103(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 103, :value => value))
    end

    def cc104(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 104, :value => value))
    end

    def cc105(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 105, :value => value))
    end

    def cc106(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 106, :value => value))
    end

    def cc107(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 107, :value => value))
    end

    def cc108(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 108, :value => value))
    end

    def cc109(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 109, :value => value))
    end

    def cc110(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 110, :value => value))
    end

    def cc111(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 111, :value => value))
    end

    def cc112(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 112, :value => value))
    end

    def cc113(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 113, :value => value))
    end

    def cc114(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 114, :value => value))
    end

    def cc115(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 115, :value => value))
    end

    def cc116(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 116, :value => value))
    end

    def cc117(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 117, :value => value))
    end

    def cc118(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 118, :value => value))
    end

    def cc119(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 119, :value => value))
    end

    def cc120(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 120, :value => value))
    end

    def cc121(value, attrs = {})
      ctl(:cc, attrs.merge(:number => 121, :value => value))
    end
  end
end
