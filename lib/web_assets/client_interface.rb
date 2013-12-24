require "erlectricity"

module WebAssets

  class ClientInterface

    attr_reader :api, :input, :output

    def initialize api, input: STDIN, output: STDOUT
      @api, @input, @output = api, input, output
    end

    def listen
      Kernel.receive input, output do |request| process request end
    end

    private

    def process request
      request.when [:append_javascript_path, String] do |path|
        reply request, api.append_javascript_path(path)
      end

      request.when [:append_stylesheet_path, String] do |path|
        reply request, api.append_stylesheet_path(path)
      end

      request.when [:javascript_filenames, String] do |filename|
        reply request, api.javascript_filenames(filename)
      end

      request.when [:javascript_content, Array] do |filename, options|
        reply request, api.javascript_content(filename, options)
      end

      request.when [:stylesheet_content, Array] do |filename, options|
        reply request, api.stylesheet_content(filename, options)
      end
    end

    def reply request, response
      request.send! response
      request.receive_loop
    end

  end

end
