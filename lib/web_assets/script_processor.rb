require "sprockets"

module WebAssets

  class ScriptProcessor

    attr_reader :environment

    def initialize
      @environment = Sprockets::Environment.new
    end

    def append_path path
      return [:error, "#{path} isn't an existing directory."] unless Dir.exists? path
      environment.append_path path
      :ok
    rescue StandardError => ex
      [:error, ex.to_s]
    end

    def paths
      environment.paths
    end

    def filenames filename
      return [] unless bundle = environment[filename]
      bundle.to_a.map(&:logical_path)
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
