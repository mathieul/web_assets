require "erlectricity"

module WebAssets

  class ClientInterface

    attr_reader :api, :input, :output

    def initialize api, input: STDIN, output: STDOUT
      @api, @input, @output = api, input, output
    end

    def listen
      Kernel.receive input, output do |request|
        WebAssets.logger.debug "ClientInterface#listen: request = #{request.inspect}"
        process request
      end
    end

    private

    def process request
      request.when [:append_javascript_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: append_javascript_path = #{path.inspect}"
        reply request, api.append_javascript_path(path)
      end

      request.when [:append_stylesheet_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: append_stylesheet_path = #{path.inspect}"
        reply request, api.append_stylesheet_path(path)
      end

      request.when [:javascript_filenames, String] do |filename|
        WebAssets.logger.debug "ClientInterface#process: javascript_filenames = #{filename.inspect}"
        reply request, api.javascript_filenames(filename)
      end

      request.when [:javascript_content, Array] do |filename, options|
        WebAssets.logger.debug "ClientInterface#process: javascript_content = #{filename.inspect}"
        reply request, api.javascript_content(filename, options)
      end

      request.when [:stylesheet_content, Array] do |filename, options|
        WebAssets.logger.debug "ClientInterface#process: stylesheet_content = #{filename.inspect}"
        reply request, api.stylesheet_content(filename, options)
      end
    end

    def reply request, response
      WebAssets.logger.debug "ClientInterface#reply: #send! #{response.inspect}"
      request.send! response
      WebAssets.logger.debug "ClientInterface#reply: #receive_loop"
      request.receive_loop
    end

  end

end
