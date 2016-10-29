RSpec.describe Destruct::Hash do
  subject { described_class.new.replace(hash) }

  let(:hash) do
    {
      status: 200,
      "multi word" => "example",
      "test" => "string"
    }
  end

  describe "#[]" do
    it "looks up by key" do
      expect(subject[:status]).to eq(200)
      expect(subject["test"]).to eq("string")
    end

    it "looks up by stringified key" do
      expect(subject[:test]).to eq("string")
    end

    it "looks up by multi-word key" do
      expect(subject["multi word"]).to eq("example")
    end

    it "looks up by index key" do
      expect(subject[0]).to eq(200)
      expect(subject[1]).to eq("example")
      expect(subject[2]).to eq("string")
      expect(subject[-1]).to eq("string")
    end

    it "returns nil when key is not found" do
      expect(subject[:invalid]).to be_nil
      expect(subject["invalid"]).to be_nil
      expect(subject[99]).to be_nil
      expect(subject[{}]).to be_nil
    end
  end

  describe "#key?" do
    it "looks up by key" do
      expect(subject).to be_key(:status)
      expect(subject).to be_key("test")
    end

    it "looks up by stringified key" do
      expect(subject).to be_key(:test)
    end

    it "looks up by multi-word key" do
      expect(subject).to be_key("multi word")
    end

    it "returns false when key is not found" do
      expect(subject).not_to be_key(:invalid)
      expect(subject).not_to be_key("invalid")
      expect(subject).not_to be_key(1)
    end
  end

  describe "#method_missing" do
    it "resolves symbol keys" do
      expect(subject.status).to eq(200)
      expect(subject.test).to eq("string")
    end

    it "resolves string keys" do
      expect(subject.test).to eq("string")
    end

    it "raises NoMethodError otherwise" do
      expect { subject.invalid }.to raise_error(NoMethodError)
    end
  end

  describe "#respond_to?" do
    it "returns true if keys exist" do
      expect(subject).to be_respond_to(:status)
      expect(subject).to be_respond_to(:test)
      expect(subject).to be_respond_to("test")
    end

    it "returns false if keys do not exist" do
      expect(subject).not_to be_respond_to(:invalid)
    end
  end

  describe "#to_ary" do
    it "returns the subject values" do
      expect(subject.to_ary).to eq(subject.values)
    end
  end
end
