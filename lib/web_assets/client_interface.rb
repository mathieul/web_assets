require "beambridge"

module WebAssets

  class ClientInterface

    attr_reader :api, :input, :output

    def initialize api, options = {}
      @api = api
      @input = options.fetch :input, STDIN
      @output = options.fetch :output, STDOUT
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
        reply request, api.set_script_path(eval_path path)
      end

      request.when [:set_stylesheet_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: set_stylesheet_path = #{path.inspect}"
        reply request, api.set_stylesheet_path(eval_path path)
      end

      request.when [:add_script_load_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: add_script_load_path = #{path.inspect}"
        reply request, api.add_script_load_path(eval_path path)
      end

      request.when [:add_stylesheet_load_path, String] do |path|
        WebAssets.logger.debug "ClientInterface#process: add_stylesheet_load_path = #{path.inspect}"
        reply request, api.add_stylesheet_load_path(eval_path path)
      end

      request.when [:script_filenames, String] do |filename|
        WebAssets.logger.debug "ClientInterface#process: script_filenames = #{filename.inspect}"
        names = api.script_filenames(filename)
        reply request, [:filenames, names]
      end

      request.when [:script_digest_filename, String] do |filename|
        WebAssets.logger.debug "ClientInterface#process: script_digest_filename = #{filename.inspect}"
        name = api.script_digest_filename(filename)
        reply request, [:filename, name]
      end

      request.when [:script_content, Array] do |(filename, options)|
        WebAssets.logger.debug "ClientInterface#process: script_content = #{filename.inspect}, #{options.inspect}"
        content = api.script_content(filename, Hash[options])
        reply request, [:content, content]
      end

      request.when [:stylesheet_digest_filename, String] do |filename|
        WebAssets.logger.debug "ClientInterface#process: stylesheet_digest_filename = #{filename.inspect}"
        name = api.stylesheet_digest_filename(filename)
        reply request, [:filename, name]
      end

      request.when [:stylesheet_content, Array] do |(filename, options)|
        WebAssets.logger.debug "ClientInterface#process: stylesheet_content = #{filename.inspect}, #{options.inspect}"
        content = api.stylesheet_content(filename, Hash[options])
        reply request, [:content, content]
      end

      WebAssets.logger.debug "ClientInterface#process: END"
    end

    def reply request, response
      WebAssets.logger.debug "ClientInterface#reply: #send!"
      request.send! response
      request.receive_loop
    end

    def eval_path path
      return path unless path.start_with? "ruby:"
      instance_eval path[5..-1]
    rescue StandardError
      "INVALID PATH"
    end

  end

end
