RSpec.describe Destruct do
  subject {
    {
      body: "test",
      headers: {
        content_type: "text/html",
        status: 200
      },
      metadata: {
        body: "duplicate",
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
        metadata
        metadata.one
        metadata[:two] if respond_to?(:anything)
        metadata.nested["multiple words"].test
      end

      expect(actual.body).to eq("test")
      expect(actual.content_type).to eq("text/html")
      expect(actual.status).to eq(200)
      expect(actual.deep).to eq(true)

      expect(actual.metadata).to eq(subject[:metadata])
      expect(actual.one).to eq(1)
      expect(actual.two).to eq(2)
      expect(actual.test).to eq("example")
    end

    it "parses keys with the same name" do
      actual = subject.destruct(:body, metadata: :body)
      expect(actual.body).to eq("duplicate")
      expect(actual.size).to eq(1)

      body, metadata_body = actual
      expect(body).to eq("test")
      expect(metadata_body).to eq("duplicate")
    end
  end
end
