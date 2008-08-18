require 'music/performer'

module Music
  class PrettyPrinter < Performer::Base
    def perform_seq(left, right, context)
      "#{left} & #{right}"
    end
    
    def perform_par(top, bottom, context)
      "(#{top}) | (#{bottom})"
    end
    
    def perform_group(arrangement, context)
      "group(#{arrangement})"
    end
    
    def perform_note(note, context)
      "note(#{note.pitch}, #{note.duration})"
    end
    
    def perform_silence(silence, context)
      "silence(#{silence.duration})"
    end
  end
end
