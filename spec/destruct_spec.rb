RSpec.describe Destruct do
  subject {
    {
      body: "test",
      headers: {
        content_type: "text/html",
        status: 200
      },
      metadata: {
        one: 1,
        two: 2,
        nested: {
          deep: true,
          "multiple words" => {
            test: "example"
          }
        }
      }
    }
  }

  describe "#destruct" do
    it "returns destruct hash" do
      actual = subject.destruct(headers: :status)
      expect(actual).to be_a(described_class::Hash)
    end

    it "splats destruct hash values" do
      search = { headers: %i(content_type status) }
      content_type, status = subject.destruct(search)
      expect(content_type).to eq("text/html")
      expect(status).to eq(200)
    end

    it "parses mixed arguments" do
      array = %i(metadata nested deep)
      hash = { headers: %i(content_type status) }

      actual = subject.destruct(:body, array, hash) do
        metadata.one
        metadata[:two]
        metadata.nested["multiple words"].test
      end

      expect(actual.body).to eq("test")
      expect(actual.content_type).to eq("text/html")
      expect(actual.status).to eq(200)
      expect(actual.deep).to eq(true)
      expect(actual.one).to eq(1)
      expect(actual.two).to eq(2)
      expect(actual.test).to eq("example")
    end
  end
end
