module Destruct
  class Hash < ::Hash
    alias_method :to_ary, :values

    def [](key)
      super(key) || super(key.to_s)
    end

    def key?(key)
      super(key) || super(key.to_s)
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
