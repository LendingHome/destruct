module Destruct
  module Object
    def destruct(*args, &block)
      args += DSL.new(&block).args if block

      args.each_with_object(Hash.new) do |path, hash|
        values = Resolver.new(self, path).to_h
        values.each { |key, value| hash[key] = value }
      end
    end

    def dig(method, *others)
      object = send(method) if respond_to?(method)
      others.any? ? object&.dig(*others) : object
    end
  end
end
