class Destruct
  class Hash < ::Hash
    def [](key)
      super(key) || super(key.to_s) || to_ary[key]
    rescue TypeError
      nil
    end

    def []=(key, value)
      to_ary << value
      super
    end

    def key?(key)
      super(key) || super(key.to_s)
    end

    def to_ary
      @to_ary ||= values
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
