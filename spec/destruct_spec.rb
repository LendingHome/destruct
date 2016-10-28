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
end
