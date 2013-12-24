require "spec_helper"

describe DynamoAssets::Api do

  subject { DynamoAssets::Api.new script_processor, stylesheet_processor }

  let(:script_processor)     { instance_double "DynamoAssets::ScriptProcessor" }
  let(:stylesheet_processor) { instance_double "DynamoAssets::StylesheetProcessor" }

  it "#append_script_path delegates to its script processor" do
    expect(script_processor)
      .to receive(:append_path)
         .with("/some/js/path")
         .and_return(:ok)

    expect(subject.append_script_path("/some/js/path")).to eq :ok
  end

  it "#append_stylesheet_path delegates to its stylesheet processor" do
    expect(stylesheet_processor)
      .to receive(:append_path)
         .with("/some/css/path")
         .and_return(:ok)

    expect(subject.append_stylesheet_path("/some/css/path")).to eq :ok
  end

  it "#script_files delegates to its script processor" do
    expect(script_processor)
      .to receive(:files)
         .with("application.js")
         .and_return(["one.js", "two.js", "application.js"])

    expect(subject.script_files("application.js")).to eq ["one.js", "two.js", "application.js"]
  end

  it "#script_content delegates to its script processor" do
    expect(script_processor)
      .to receive(:content)
         .with("application.js", bundle: true, minify: true, gzip: false)
         .and_return("js content")

    expect(subject.script_content("application.js", minify: true)).to eq "js content"
  end

  it "#stylesheet_content delegates to its stylesheet processor" do
    expect(stylesheet_processor)
      .to receive(:content)
         .with("application.css", minify: true, gzip: false)
         .and_return("css content")

    expect(subject.stylesheet_content("application.css", minify: true)).to eq "css content"
  end

end
