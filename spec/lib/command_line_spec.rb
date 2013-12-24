require "spec_helper"

describe WebAssets::CommandLine do

  subject { WebAssets::CommandLine }

  context "#parse" do

    it "specifies a library name to load with --require" do
      options = subject.new(%w[--require blah]).parse
      expect(options[:require]).to eq ["blah"]
    end

    it "can specify multiple libraries" do
      options = subject.new(%w[-r one -r two -r three]).parse
      expect(options[:require]).to eq ["one", "two", "three"]
    end

    it "can set the debug flag" do
      options = subject.new(%w[-d]).parse
      expect(options[:debug]).to eq true
    end

  end

end
