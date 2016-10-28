module Destruct
  class Hash < SimpleDelegator
    def [](key)
      __getobj__[key] || __getobj__[key.to_s]
    end

    def key?(key)
      __getobj__.key?(key) || __getobj__.key?(key.to_s)
    end

    def to_ary
      __getobj__.values
    end

    def update(*args)
      hash = __getobj__.update(*args)
      self.class.new(hash)
    end

    private

    def method_missing(method, *)
      key?(method) ? self[method] : super
    end

    def respond_to_missing?(method, *)
      key?(method) || super
    end
  end
end
