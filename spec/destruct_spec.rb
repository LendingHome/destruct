RSpec.describe Destruct do
  subject {
    {
      body: {
        teams: [1, 2, 3],
        users: [1, 2, 3]
      },
      headers: {
        content_type: "application/json",
        status: 200
      },
      metadata: {
        one: 1,
        two: 2
      }
    }
  }

  def destruct(*args, &block)
    subject.destruct(*args, &block)
  end

  describe "#destruct" do
    it "returns destruct object" do
      actual = destruct(headers: :status)

      expect(actual[:status]).to eq(200)
      expect(actual.status).to eq(200)

      expect(actual[:invalid]).to be_nil
      expect { actual.invalid }.to raise_error(NoMethodError)
    end

    it "destructs arguments" do
      content_type, status = destruct(headers: [:content_type, :status])
      expect(content_type).to eq("application/json")
      expect(status).to eq(200)
    end
  end

	describe "#gemspec" do
    it "returns a gemspec object" do
      expect(described_class.gemspec).to be_a(Gem::Specification)
    end
  end

  describe "#root" do
    it "returns a pathname object" do
      expect(described_class.root).to be_a(Pathname)
    end
  end

  describe "#version" do
    it "returns a version string" do
      expect(described_class.version).to match(/^\d+\.\d+\.\d+$/)
    end
  end
end
