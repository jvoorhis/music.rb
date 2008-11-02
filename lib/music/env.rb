module Music
  class Env
    def initialize(&fn)
      @fn = fn
    end
    
    def apply(val, phase)
      @fn.call(val, phase)
    end
  end
end
