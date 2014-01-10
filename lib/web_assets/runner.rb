module WebAssets

  class Runner

    attr_reader :libs

    def initialize arguments
      options = CommandLine.new(arguments).parse
      WebAssets.debug = options.fetch :debug, false
      @libs = options.fetch :libs, []
    end

    def run
      WebAssets.logger.debug "Runner#run: >>>"
      load_libs
      listen_to_client
      WebAssets.logger.debug "Runner#run: <<<"
    end

    private

    def load_libs
      libs.each { |lib| require lib }
    end

    def listen_to_client
      api = Api.new script_processor, stylesheet_processor
      client_interface = ClientInterface.new api, input: STDIN, output: STDOUT
      client_interface.listen
    end

    def script_processor
      ScriptProcessor.new
    end

    def stylesheet_processor
      StylesheetProcessor.new
    end

  end

end
