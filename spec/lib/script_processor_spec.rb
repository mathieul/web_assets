require "spec_helper"

describe WebAssets::ScriptProcessor do

  let(:js_fixture_path) { File.expand_path("../fixtures/javascripts", __dir__) }

  context "#append_path" do

    it "returns an error if the path doesn't exist" do
      expect(subject.append_path("/doesnt/exist")).to eq [:error, "/doesnt/exist isn't an existing directory."]
    end

    it "adds the path to the processor load path" do
      expect(subject.append_path(__dir__)).to eq :ok
      expect(subject.paths).to eq [__dir__]
    end

  end

  context "#filenames" do

    it "returns an empty list if the file doesn't exist" do
      expect(subject.filenames("no/file.js")).to eq []
    end

    it "returns the list of file dependencies and the file" do
      subject.append_path js_fixture_path

      expect(subject.filenames("application.js")).to eq ["lib/useful.js", "application.js"]
    end

  end

  context "#content" do

    before :each do
      subject.append_path js_fixture_path
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

end