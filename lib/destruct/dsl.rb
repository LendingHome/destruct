module Destruct
  class DSL
    attr_reader :args

    def initialize(&block)
      @args = []
      instance_eval(block) if block
    end
  end
end
