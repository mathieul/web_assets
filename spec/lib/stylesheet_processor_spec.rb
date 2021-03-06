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

    it "returns an empty string if the file doesn't exist" do
      expect(subject.content("no/file.css", {})).to eq ""
    end

    it "returns the css file content if it does exist" do
      content = subject.content("static.css", {})
      expect(content).to eq "body { background-color: #f1f1f1; }\n"
    end

    it "returns the pre-processed file content if it exists" do
      content = subject.content("application.css", {})
      expect(content).to match /color: #dd1111;/
    end

    it "returns the content minified if :minify is true" do
      content = subject.content("application.css", minify: true)
      expect(content).to eq "h1{color:#d11}\n"
    end

    it "returns the content gzipped if :gzip is true" do
      gzipped = subject.content("application.css", gzip: true, minify: true)
      content = WebAssets::Gzipper.uncompress gzipped
      expect(content).to eq "h1{color:#d11}\n"
    end

  end

  context "#digest_filename" do

    before :each do
      subject.set_path css_fixture_path
    end

    it "returns an empty string if the file doesn't exist" do
      expect(subject.digest_filename("no/file.css")).to eq ""
    end

    it "returns the digest filename if the file exists" do
      expect(subject.digest_filename("application.css")).to eq "application-1fc624e75863496c475c1f71d5d4d1e0.css"
    end

  end

end
