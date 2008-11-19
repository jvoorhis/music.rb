module Music
  module MIDI
    class MidiTime
      attr :resolution
      
      def initialize(res)
        @resolution = res
      end
      
      def ppqn(val)
        case val
          when Numeric
            (val * resolution).round
          else
            raise ArgumentError, "Cannot convert #{val}:#{val.class} to midi time."
        end
      end
    end
  end
end
