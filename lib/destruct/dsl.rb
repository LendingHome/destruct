class Destruct
  class DSL
    def initialize(&block)
      @paths = {}
      instance_eval(&block) if block
    end

    def [](path)
      self.class.new.tap do |dsl|
        @paths[path] = dsl
      end
    end

    def paths
      @paths.to_a
    end

    private

    def method_missing(method, *)
      self[method]
    end

    def respond_to_missing?(method, *)
      true
    end
  end
end
