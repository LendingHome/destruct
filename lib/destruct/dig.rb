module Destruct
  class Dig
    def initialize(object, *args)
      @object = object
      @args = args
    end

    def to_h
      @object.dig(*@args.first.keys)
    end
  end
end
