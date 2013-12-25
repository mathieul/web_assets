require "spec_helper"

describe WebAssets::ScriptProcessor do

  let(:js_fixture_path) { File.expand_path("../fixtures/javascripts", __dir__) }

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

  context "#filenames" do

    it "returns an empty list if the file doesn't exist" do
      expect(subject.filenames("no/file.js")).to eq []
    end

    it "returns the list of file dependencies and the file" do
      subject.set_path js_fixture_path

      expect(subject.filenames("application.js")).to eq ["lib/useful.js", "application.js"]
    end

  end

  context "#content" do

    before :each do
      subject.set_path js_fixture_path
    end

    it "returns an empty string if the file doesn't exist" do
      expect(subject.content("no/file.js", {})).to eq ""
    end

    it "returns the file content unless :bundle is true" do
      content = subject.content("application.js", {})
      expect(content).to eq "var main = true;\n"
    end

    it "returns the file bundle content if :bundle is true" do
      content = subject.content("application.js", bundle: true)
      expect(content).to eq "(function() {\n  console.log(\"in useful\");\n\n}).call(this);\nvar main = true;\n"
    end

    it "returns the content minified if :minify is true" do
      content = subject.content("application.js", bundle: true, minify: true)
      expect(content).to eq "(function(){console.log(\"in useful\")}).call(this);var main=!0;"
    end

    it "returns the content gzipped if :gzip is true" do
      content = subject.content("application.js", bundle: true, minify: true, gzip: true)
      expect(content[0]).to eq "\u001F"
      expect(content[-1]).to eq "\u0000"
      expect(content.length).to eq 78
    end

  end

  context "#digest_filename" do

    before :each do
      subject.set_path js_fixture_path
    end

    it "returns an empty string if the file doesn't exist" do
      expect(subject.digest_filename("no/file.js")).to eq ""
    end

    it "returns the digest filename if the file exists" do
      expect(subject.digest_filename("application.js")).to eq "application-73b969089909eeeaab9f39768912d755.js"
    end

  end

end
