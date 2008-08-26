module Music
  module Attributes
    def method_missing(sym, *args)
      if block_given?
        update_attribute(sym, yield(read_attribute(sym)))
      elsif args.empty? && !block_given?
        read_attribute(sym)
      elsif args.one?
        update_attribute(sym, args.first)
      else
        super
      end
    end
  end
end
