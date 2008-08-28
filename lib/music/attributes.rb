module Music
  module Attributes
    def method_missing(name, *args)
      if block_given?
        if val = read(name)
          update(name, yield(val))
        else
          self
        end
      elsif args.empty? && !block_given?
        read(name)
      elsif args.one?
        update(name, args.first)
      else
        super
      end
    end
  end
end
