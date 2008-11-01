module Music
  class Env
    def initialize(&fn)
      @fn = fn
    end
    
    def apply(name, val, context)
      @fn.call(val, context.phase)
    end
  end
end
