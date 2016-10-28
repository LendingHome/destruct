module Destruct
  module Object
    def destruct(*args)
      args.each_with_object(Hash.new) do |arg, hash|
        values = Resolver.new(self, arg).to_h
        values.each { |key, value| hash[key] = value }
      end
    end

    def dig(method, *others)
      object = send(method) if respond_to?(method)
      others.any? ? object&.dig(*others) : object
    end
  end
end
