require 'music'

module Music
  class MusicObject
    def fmap; raise NotImplementedError end
  end
  
  class Seq
    def fmap(&block)
      Seq.new(left.fmap(&block), right.fmap(&block))
    end
  end
  
  class Par
    def fmap(&block)
      Par.new(top.fmap(&block), bottom.fmap(&block))
    end
  end
  
  class Group
    def fmap(&block)
      Group.new(music.fmap(&block), attributes)
    end
  end
  
  class Note
    def fmap; yield self end
  end
  
  class Silence
    def fmap; yield self end
  end
end
