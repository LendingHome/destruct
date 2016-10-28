class Destruct
  module Object
    def destruct(*paths, &block)
      Destruct.new(self, *paths, &block).to_h
    end

    def dig(method, *paths)
      object = send(method) if respond_to?(method)
      paths.any? ? object&.dig(*paths) : object
    end
  end
end
