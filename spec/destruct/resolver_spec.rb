RSpec.describe Destruct::Resolver do
  subject { described_class.new(object, path) }

  let(:object) { "test" }

  describe "#to_h" do
    let(:path) { :upcase }

    context "with object argument" do
      it "parses correctly" do
        expect(subject.to_h).to eq(upcase: "TEST")
      end
    end

    context "with array argument" do
      let(:path) { %i(upcase reverse) }

      it "parses correctly" do
        expect(subject.to_h).to eq(reverse: "TSET")
      end
    end

    context "with hash argument" do
      let(:path) { { upcase: :reverse } }

      it "parses correctly" do
        expect(subject.to_h).to eq(reverse: "TSET")
      end
    end
  end
end
