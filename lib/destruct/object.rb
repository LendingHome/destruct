module Destruct
  module Object
    def destruct(*args)
      args.each_with_object(Hash.new) do |arg, hash|
        values = Dig.new(self, arg).to_h
        values.each { |key, value| hash[key] = value }
      end
    end

    def dig(*methods)
      methods.reduce(self) do |object, method|
        object.send(method) if object.respond_to?(method)
      end
    end
  end
end
