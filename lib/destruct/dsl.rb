class Destruct
  class DSL
    def initialize(&block)
      instance_eval(&block)
    end

    def paths
      @paths ||= []
    end
  end
end
