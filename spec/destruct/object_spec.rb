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
