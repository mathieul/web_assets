require "optparse"

module WebAssets

  class CommandLine

    attr_reader :arguments

    def initialize arguments
      @arguments = arguments
    end

    def parse
      options = {require: [], debug: false}
      parser(options).parse! arguments
      options
    end

    private

    def parser options
      OptionParser.new do |o|
        o.on "-r", "--require LIB", "require the library specified" do |lib|
          options[:libs] << lib
        end

        o.on "-d", "--debug", "trace execution in a log file" do |debug|
          options[:debug] = debug
        end
      end
    end

  end

end
