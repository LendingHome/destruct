RSpec.describe Destruct::Object do
  subject { "test" }

  describe "#destruct" do
    it "is defined on all objects" do
      expect(subject).to respond_to(:destruct)
      expect(Object).to respond_to(:destruct)
      expect(Object.new).to respond_to(:destruct)
    end
  end

  describe "#dig" do
    it "resolves nested methods" do
      actual = subject.dig(:upcase, :reverse)
      expect(actual).to eq("TSET")
    end

    it "resolves nested hashes" do
      struct = Struct.new(:hash)
      object = struct.new(one: { two: 2 })
      actual = object.dig(:hash, :one, :two)
      expect(actual).to eq(2)
    end

    it "resolves nested arrays" do
      struct = Struct.new(:array)
      object = struct.new([1, [2, 3]])
      actual = object.dig(:array, 1, 0)
      expect(actual).to eq(2)
    end

    it "returns nil for undefined methods" do
      actual = subject.dig(:upcase, :undefined, :reverse)
      expect(actual).to be_nil
    end

    it "returns nil for invalid methods" do
      actual = subject.dig(:upcase, "invalid method", :reverse)
      expect(actual).to be_nil
    end
  end
end
