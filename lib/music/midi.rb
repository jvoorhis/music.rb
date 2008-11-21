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
      ctl(:cc0, attrs.merge(:value => value))
    end
    
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

    def cc17(value, attrs = {})
      ctl(:cc17, attrs.merge(:value => value))
    end

    def cc18(value, attrs = {})
      ctl(:cc18, attrs.merge(:value => value))
    end

    def cc19(value, attrs = {})
      ctl(:cc19, attrs.merge(:value => value))
    end

    def cc20(value, attrs = {})
      ctl(:cc20, attrs.merge(:value => value))
    end

    def cc21(value, attrs = {})
      ctl(:cc21, attrs.merge(:value => value))
    end

    def cc22(value, attrs = {})
      ctl(:cc22, attrs.merge(:value => value))
    end

    def cc23(value, attrs = {})
      ctl(:cc23, attrs.merge(:value => value))
    end

    def cc24(value, attrs = {})
      ctl(:cc24, attrs.merge(:value => value))
    end

    def cc25(value, attrs = {})
      ctl(:cc25, attrs.merge(:value => value))
    end

    def cc26(value, attrs = {})
      ctl(:cc26, attrs.merge(:value => value))
    end

    def cc27(value, attrs = {})
      ctl(:cc27, attrs.merge(:value => value))
    end

    def cc28(value, attrs = {})
      ctl(:cc28, attrs.merge(:value => value))
    end

    def cc29(value, attrs = {})
      ctl(:cc29, attrs.merge(:value => value))
    end

    def cc30(value, attrs = {})
      ctl(:cc30, attrs.merge(:value => value))
    end

    def cc31(value, attrs = {})
      ctl(:cc31, attrs.merge(:value => value))
    end

    def cc32(value, attrs = {})
      ctl(:cc32, attrs.merge(:value => value))
    end

    def cc33(value, attrs = {})
      ctl(:cc33, attrs.merge(:value => value))
    end

    def cc34(value, attrs = {})
      ctl(:cc34, attrs.merge(:value => value))
    end

    def cc35(value, attrs = {})
      ctl(:cc35, attrs.merge(:value => value))
    end

    def cc36(value, attrs = {})
      ctl(:cc36, attrs.merge(:value => value))
    end

    def cc37(value, attrs = {})
      ctl(:cc37, attrs.merge(:value => value))
    end

    def cc38(value, attrs = {})
      ctl(:cc38, attrs.merge(:value => value))
    end

    def cc39(value, attrs = {})
      ctl(:cc39, attrs.merge(:value => value))
    end

    def cc40(value, attrs = {})
      ctl(:cc40, attrs.merge(:value => value))
    end

    def cc41(value, attrs = {})
      ctl(:cc41, attrs.merge(:value => value))
    end

    def cc42(value, attrs = {})
      ctl(:cc42, attrs.merge(:value => value))
    end

    def cc43(value, attrs = {})
      ctl(:cc43, attrs.merge(:value => value))
    end

    def cc44(value, attrs = {})
      ctl(:cc44, attrs.merge(:value => value))
    end

    def cc45(value, attrs = {})
      ctl(:cc45, attrs.merge(:value => value))
    end

    def cc46(value, attrs = {})
      ctl(:cc46, attrs.merge(:value => value))
    end

    def cc47(value, attrs = {})
      ctl(:cc47, attrs.merge(:value => value))
    end

    def cc48(value, attrs = {})
      ctl(:cc48, attrs.merge(:value => value))
    end

    def cc49(value, attrs = {})
      ctl(:cc49, attrs.merge(:value => value))
    end

    def cc50(value, attrs = {})
      ctl(:cc50, attrs.merge(:value => value))
    end

    def cc51(value, attrs = {})
      ctl(:cc51, attrs.merge(:value => value))
    end

    def cc52(value, attrs = {})
      ctl(:cc52, attrs.merge(:value => value))
    end

    def cc53(value, attrs = {})
      ctl(:cc53, attrs.merge(:value => value))
    end

    def cc54(value, attrs = {})
      ctl(:cc54, attrs.merge(:value => value))
    end

    def cc55(value, attrs = {})
      ctl(:cc55, attrs.merge(:value => value))
    end

    def cc56(value, attrs = {})
      ctl(:cc56, attrs.merge(:value => value))
    end

    def cc57(value, attrs = {})
      ctl(:cc57, attrs.merge(:value => value))
    end

    def cc58(value, attrs = {})
      ctl(:cc58, attrs.merge(:value => value))
    end

    def cc59(value, attrs = {})
      ctl(:cc59, attrs.merge(:value => value))
    end

    def cc60(value, attrs = {})
      ctl(:cc60, attrs.merge(:value => value))
    end

    def cc61(value, attrs = {})
      ctl(:cc61, attrs.merge(:value => value))
    end

    def cc62(value, attrs = {})
      ctl(:cc62, attrs.merge(:value => value))
    end

    def cc63(value, attrs = {})
      ctl(:cc63, attrs.merge(:value => value))
    end

    def cc64(value, attrs = {})
      ctl(:cc64, attrs.merge(:value => value))
    end

    def cc65(value, attrs = {})
      ctl(:cc65, attrs.merge(:value => value))
    end

    def cc66(value, attrs = {})
      ctl(:cc66, attrs.merge(:value => value))
    end

    def cc67(value, attrs = {})
      ctl(:cc67, attrs.merge(:value => value))
    end

    def cc68(value, attrs = {})
      ctl(:cc68, attrs.merge(:value => value))
    end

    def cc69(value, attrs = {})
      ctl(:cc69, attrs.merge(:value => value))
    end

    def cc70(value, attrs = {})
      ctl(:cc70, attrs.merge(:value => value))
    end

    def cc71(value, attrs = {})
      ctl(:cc71, attrs.merge(:value => value))
    end

    def cc72(value, attrs = {})
      ctl(:cc72, attrs.merge(:value => value))
    end

    def cc73(value, attrs = {})
      ctl(:cc73, attrs.merge(:value => value))
    end

    def cc74(value, attrs = {})
      ctl(:cc74, attrs.merge(:value => value))
    end

    def cc75(value, attrs = {})
      ctl(:cc75, attrs.merge(:value => value))
    end

    def cc76(value, attrs = {})
      ctl(:cc76, attrs.merge(:value => value))
    end

    def cc77(value, attrs = {})
      ctl(:cc77, attrs.merge(:value => value))
    end

    def cc78(value, attrs = {})
      ctl(:cc78, attrs.merge(:value => value))
    end

    def cc79(value, attrs = {})
      ctl(:cc79, attrs.merge(:value => value))
    end

    def cc80(value, attrs = {})
      ctl(:cc80, attrs.merge(:value => value))
    end

    def cc81(value, attrs = {})
      ctl(:cc81, attrs.merge(:value => value))
    end

    def cc82(value, attrs = {})
      ctl(:cc82, attrs.merge(:value => value))
    end

    def cc83(value, attrs = {})
      ctl(:cc83, attrs.merge(:value => value))
    end

    def cc84(value, attrs = {})
      ctl(:cc84, attrs.merge(:value => value))
    end

    def cc85(value, attrs = {})
      ctl(:cc85, attrs.merge(:value => value))
    end

    def cc86(value, attrs = {})
      ctl(:cc86, attrs.merge(:value => value))
    end

    def cc87(value, attrs = {})
      ctl(:cc87, attrs.merge(:value => value))
    end

    def cc88(value, attrs = {})
      ctl(:cc88, attrs.merge(:value => value))
    end

    def cc89(value, attrs = {})
      ctl(:cc89, attrs.merge(:value => value))
    end

    def cc90(value, attrs = {})
      ctl(:cc90, attrs.merge(:value => value))
    end

    def cc91(value, attrs = {})
      ctl(:cc91, attrs.merge(:value => value))
    end

    def cc92(value, attrs = {})
      ctl(:cc92, attrs.merge(:value => value))
    end

    def cc93(value, attrs = {})
      ctl(:cc93, attrs.merge(:value => value))
    end

    def cc94(value, attrs = {})
      ctl(:cc94, attrs.merge(:value => value))
    end

    def cc95(value, attrs = {})
      ctl(:cc95, attrs.merge(:value => value))
    end

    def cc96(value, attrs = {})
      ctl(:cc96, attrs.merge(:value => value))
    end

    def cc97(value, attrs = {})
      ctl(:cc97, attrs.merge(:value => value))
    end

    def cc98(value, attrs = {})
      ctl(:cc98, attrs.merge(:value => value))
    end

    def cc99(value, attrs = {})
      ctl(:cc99, attrs.merge(:value => value))
    end

    def cc100(value, attrs = {})
      ctl(:cc100, attrs.merge(:value => value))
    end

    def cc101(value, attrs = {})
      ctl(:cc101, attrs.merge(:value => value))
    end

    def cc102(value, attrs = {})
      ctl(:cc102, attrs.merge(:value => value))
    end

    def cc103(value, attrs = {})
      ctl(:cc103, attrs.merge(:value => value))
    end

    def cc104(value, attrs = {})
      ctl(:cc104, attrs.merge(:value => value))
    end

    def cc105(value, attrs = {})
      ctl(:cc105, attrs.merge(:value => value))
    end

    def cc106(value, attrs = {})
      ctl(:cc106, attrs.merge(:value => value))
    end

    def cc107(value, attrs = {})
      ctl(:cc107, attrs.merge(:value => value))
    end

    def cc108(value, attrs = {})
      ctl(:cc108, attrs.merge(:value => value))
    end

    def cc109(value, attrs = {})
      ctl(:cc109, attrs.merge(:value => value))
    end

    def cc110(value, attrs = {})
      ctl(:cc110, attrs.merge(:value => value))
    end

    def cc111(value, attrs = {})
      ctl(:cc111, attrs.merge(:value => value))
    end

    def cc112(value, attrs = {})
      ctl(:cc112, attrs.merge(:value => value))
    end

    def cc113(value, attrs = {})
      ctl(:cc113, attrs.merge(:value => value))
    end

    def cc114(value, attrs = {})
      ctl(:cc114, attrs.merge(:value => value))
    end

    def cc115(value, attrs = {})
      ctl(:cc115, attrs.merge(:value => value))
    end

    def cc116(value, attrs = {})
      ctl(:cc116, attrs.merge(:value => value))
    end

    def cc117(value, attrs = {})
      ctl(:cc117, attrs.merge(:value => value))
    end

    def cc118(value, attrs = {})
      ctl(:cc118, attrs.merge(:value => value))
    end

    def cc119(value, attrs = {})
      ctl(:cc119, attrs.merge(:value => value))
    end

    def cc120(value, attrs = {})
      ctl(:cc120, attrs.merge(:value => value))
    end

    def cc121(value, attrs = {})
      ctl(:cc121, attrs.merge(:value => value))
    end
  end
end
