require "spec_helper"

describe WebAssets::StylesheetProcessor do

  let(:css_fixture_path) { File.expand_path("../fixtures/stylesheets", __dir__) }

  context "#set_path" do

    it "returns an error if the path doesn't exist" do
      result = subject.set_path("/doesnt/exist")
      expect(result).to eq [:error, "/doesnt/exist isn't an existing directory."]
    end

    it "sets the stylesheet files path" do
      expect(subject.set_path(__dir__)).to eq :ok
    end

  end

  context "#add_load_path" do

    it "returns an error if the path doesn't exist" do
      result = subject.add_load_path("/doesnt/exist")
      expect(result).to eq [:error, "/doesnt/exist isn't an existing directory."]
    end

    it "adds the path to the processor load path" do
      expect(subject.add_load_path(__dir__)).to eq :ok
      expect(subject.paths).to eq [__dir__]
    end

  end

  context "#content" do

    before :each do
      subject.set_path css_fixture_path
    end

    it "returns an empty string if the file doesn't exist"

    it "returns the file content unless :bundle is true"

    it "returns the file bundle content if :bundle is true"

    it "returns the content minified if :minify is true"

    it "returns the content gzipped if :gzip is true"

  end

  context "#digest_filename" do

    before :each do
      subject.set_path css_fixture_path
    end

    it "returns an empty string if the file doesn't exist"

    it "returns the digest filename if the file exists"

  end

end
