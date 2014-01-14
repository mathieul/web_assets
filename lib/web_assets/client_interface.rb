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
      WebAssets.logger.debug "ClientInterface#process: START #{request.inspect}"

      request.when [:set_script_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: set_script_path = #{path.inspect}"
        reply request, api.set_script_path(path)
      end

      request.when [:set_stylesheet_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: set_stylesheet_path = #{path.inspect}"
        reply request, api.set_stylesheet_path(path)
      end

      request.when [:add_script_load_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: add_script_load_path = #{path.inspect}"
        reply request, api.add_script_load_path(path)
      end

      request.when [:add_stylesheet_load_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: add_stylesheet_load_path = #{path.inspect}"
        reply request, api.add_stylesheet_load_path(path)
      end

      request.when [:script_filenames, String] do |filename|
        WebAssets.logger.debug "ClientInterface#process: script_filenames = #{filename.inspect}"
        reply request, api.script_filenames(filename)
      end

      request.when [:script_digest_filename, String] do |filename|
        WebAssets.logger.debug "ClientInterface#process: script_digest_filename = #{filename.inspect}"
        reply request, api.script_digest_filename(filename)
      end

      request.when [:script_content, Array] do |filename, options|
        WebAssets.logger.debug "ClientInterface#process: script_content = #{filename.inspect}"
        reply request, api.script_content(filename, options)
      end

      request.when [:stylesheet_digest_filename, String] do |filename|
        WebAssets.logger.debug "ClientInterface#process: stylesheet_digest_filename = #{filename.inspect}"
        reply request, api.stylesheet_digest_filename(filename)
      end

      request.when [:stylesheet_content, Array] do |filename, options|
        WebAssets.logger.debug "ClientInterface#process: stylesheet_content = #{filename.inspect}"
        reply request, api.stylesheet_content(filename, options)
      end

      WebAssets.logger.debug "ClientInterface#process: END"
    end

    def reply request, response
      WebAssets.logger.debug "ClientInterface#reply: #send! #{response.inspect}"
      request.send! response
      WebAssets.logger.debug "ClientInterface#reply: #receive_loop"
      request.receive_loop
    end

  end

end
