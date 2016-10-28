module Destruct
  class Dig
    def initialize(object, *args)
      @object = object
      @args = args
    end

    def dig
      @object.dig(*@args.first.keys)
    end

    def to_h
      Hash.new(dig)
    end
  end
end
