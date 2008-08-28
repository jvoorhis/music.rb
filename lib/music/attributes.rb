module Music
  module Attributes
    def method_missing(name, *args)
      if block_given?
        if val = read_attribute(name)
          update_attribute(name, yield(val))
        else
          self
        end
      elsif args.empty? && !block_given?
        read_attribute(name)
      elsif args.one?
        update_attribute(name, args.first)
      else
        super
      end
    end
  end
end
