class Destruct
  module Object
    def destruct(*args, &block)
      Destruct.new(self, *args, &block).to_h
    end

    def dig(method, *others)
      object = send(method) if respond_to?(method)
      others.any? ? object&.dig(*others) : object
    end
  end
end
