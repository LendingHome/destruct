module Destruct
  class Dig
    def initialize(object, path)
      @object = object
      @path = path
    end

    def to_h
      @object.dig(*@path.keys)
    end
  end
end
