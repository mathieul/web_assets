require "sprockets"
require "web_assets/gzipper"

module WebAssets

  class ScriptProcessor

    attr_reader :environment

    def initialize
      @environment = Sprockets::Environment.new
      if defined?(HandlebarsAssets)
        environment.append_path(HandlebarsAssets.path)
      end
    end

    def set_path path
      return [:error, "#{path} isn't an existing directory."] unless Dir.exists? path
      WebAssets.logger.debug "ScriptProcessor#set_path #{path.inspect}"
      environment.prepend_path path
      :ok
    end

    def add_load_path path
      return [:error, "#{path} isn't an existing directory."] unless Dir.exists? path
      WebAssets.logger.debug "ScriptProcessor#add_load_path #{path.inspect}"
      environment.append_path path
      :ok
    end

    def paths
      environment.paths.dup
    end

    def filenames filename
      return [] unless bundle = environment[filename]
      WebAssets.logger.debug "ScriptProcessor#filenames #{filename.inspect}"
      bundle.to_a.map(&:logical_path)
    end

    def digest_filename filename
      return "" unless bundle = environment[filename]
      WebAssets.logger.debug "ScriptProcessor#digest_filename #{filename.inspect}"
      bundle.digest_path
    end

    def content filename, options
      environment.js_compressor = options[:minify] ? :uglifier : nil
      return "" unless bundle = environment[filename]
      WebAssets.logger.debug "ScriptProcessor#content #{filename.inspect}"
      content = options[:bundle] ? bundle.to_s : bundle.body
      options[:gzip] ? Gzipper.compress(content) : content
    end

  end

end
