require "spec_helper"

describe WebAssets::Api do

  subject { WebAssets::Api.new script_processor, stylesheet_processor }

  let(:script_processor)     { instance_double "WebAssets::ScriptProcessor" }
  let(:stylesheet_processor) { instance_double "WebAssets::StylesheetProcessor" }

  it "#append_script_path delegates to its script processor" do
    expect(script_processor)
      .to receive(:add_load_path)
         .with("/some/js/path")
         .and_return(:ok)

    expect(subject.append_script_path("/some/js/path")).to eq :ok
  end

  it "#append_stylesheet_path delegates to its stylesheet processor" do
    expect(stylesheet_processor)
      .to receive(:add_load_path)
         .with("/some/css/path")
         .and_return(:ok)

    expect(subject.append_stylesheet_path("/some/css/path")).to eq :ok
  end

  it "#script_filenames delegates to its script processor" do
    expect(script_processor)
      .to receive(:filenames)
         .with("application.js")
         .and_return(["one.js", "two.js", "application.js"])

    expect(subject.script_filenames("application.js")).to eq ["one.js", "two.js", "application.js"]
  end

  it "#script_digest_filename delegates to its script processor" do
    expect(script_processor)
      .to receive(:digest_filename)
         .with("application.js")
         .and_return("application-123123123.js")

    expect(subject.script_digest_filename("application.js")).to eq "application-123123123.js"
  end

  it "#script_content delegates to its script processor" do
    expect(script_processor)
      .to receive(:content)
         .with("application.js", bundle: true, minify: true, gzip: false)
         .and_return("js content")

    expect(subject.script_content("application.js", minify: true)).to eq "js content"
  end

  it "#stylesheet_digest_filename delegates to its stylesheet processor" do
    expect(stylesheet_processor)
      .to receive(:digest_filename)
         .with("application.css")
         .and_return("application-42424242.css")

    expect(subject.stylesheet_digest_filename("application.css")).to eq "application-42424242.css"
  end

  it "#stylesheet_content delegates to its stylesheet processor" do
    expect(stylesheet_processor)
      .to receive(:content)
         .with("application.css", minify: true, gzip: false)
         .and_return("css content")

    expect(subject.stylesheet_content("application.css", minify: true)).to eq "css content"
  end

end
