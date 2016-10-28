class Destruct
  class DSL
    def initialize(&block)
      @paths = {}
      instance_eval(&block) if block
    end

    def [](path)
      @paths[path] ||= self.class.new
    end

    def paths
      @paths.each_with_object([]) do |(key, dsl), paths|
        nested = dsl.paths
        paths << [key] if nested.empty?
        nested.each { |path| paths << path.unshift(key) }
      end
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
