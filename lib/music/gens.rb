module Music
  class Gen
    def initialize(&fn)
      @fn = fn
    end
    
    def apply(name, val, context)
      @fn.call(context)
    end
  end
  
  class Tr < Gen
    def apply(name, val, context)
      @fn.call(val)
    end
  end
  
  class Env < Gen
    def apply(name, val, context)
      @fn.call(val, context.phase)
    end
  end
end
