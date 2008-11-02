require 'music/interpreter'

module Music
  class PrettyPrinter < Interpreter::Base
    def eval_seq(left, right, context)
      "#{left} & #{right}"
    end
    
    def eval_par(top, bottom, context)
      "(#{top}) | (#{bottom})"
    end
    
    def eval_group(arrangement, context)
      "group(#{arrangement})"
    end
    
    def eval_note(note, context)
      "note(#{note.pitch}, #{note.duration})"
    end
    
    def eval_rest(rest, context)
      "rest(#{rest.duration})"
    end
  end
end
