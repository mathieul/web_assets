require "sprockets"

module WebAssets

  class ScriptProcessor

    attr_reader :environment

    def initialize
      @environment = Sprockets::Environment.new
    end

    def set_path path
      return [:error, "#{path} isn't an existing directory."] unless Dir.exists? path
      environment.prepend_path path
      :ok
    end

    def add_load_path path
      return [:error, "#{path} isn't an existing directory."] unless Dir.exists? path
      environment.append_path path
      :ok
    end

    def paths
      environment.paths.dup
    end

    def filenames filename
      return [] unless bundle = environment[filename]
      bundle.to_a.map(&:logical_path)
    end

    def digest_filename filename
      return "" unless bundle = environment[filename]
      bundle.digest_path
    end

    def content filename, options
      environment.js_compressor = options[:minify] ? :uglifier : nil
      return "" unless bundle = environment[filename]
      content = options[:bundle] ? bundle.to_s : bundle.body
      options[:gzip] ? gzip(content) : content
    end

    private

    def gzip content
      stream = StringIO.new
      gz = Zlib::GzipWriter.new stream
      gz.write content
      gz.close
      stream.string
    end

  end

end
