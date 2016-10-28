module Destruct
  module Object
    # def destruct(*args)
    #   args.reduce(Hash.new) do |hash, arg|
    #     dig = Dig.new(self, arg)
    #     hash.update(dig.to_h)
    #   end
    # end

    def destruct(*args)
      Dig.new(self, *args).to_h
    end

    def dig(*methods)
      methods.reduce(self) do |object, method|
        object.send(method) if object.respond_to?(method)
      end
    end
  end
end
