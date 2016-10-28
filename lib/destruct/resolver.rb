class Destruct
  class Resolver
    def initialize(object, path)
      @object = object
      @path = path
    end

    def to_h
      case @path
      when Array
        { @path.last => @object.dig(*@path) }
      when ::Hash
        resolve_recursively
      else
        self.class.new(@object, paths).to_h
      end
    end

    private

    def paths
      Array(@path)
    end

    def resolve(key, values)
      @object.dig(key).tap do |object|
        Array(values).each do |value|
          yield self.class.new(object, value)
        end
      end
    end

    def resolve_recursively
      @path.each_with_object({}) do |(key, values), hash|
        resolve(key, values) do |resolver|
          hash.update(resolver.to_h)
        end
      end
    end
  end
end
