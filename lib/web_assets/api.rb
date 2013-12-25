module WebAssets

  class Api

    attr_reader :script_processor, :stylesheet_processor

    def initialize script_processor, stylesheet_processor
      @script_processor     = script_processor
      @stylesheet_processor = stylesheet_processor
    end

    def append_script_path path
      script_processor.add_load_path path
    end

    def append_stylesheet_path path
      stylesheet_processor.add_load_path path
    end

    def script_filenames filename
      script_processor.filenames filename
    end

    def script_digest_filename filename
      script_processor.digest_filename filename
    end

    def script_content filename, options = {}
      options[:bundle] = options.fetch :bundle, true
      options[:minify] = options.fetch :minify, false
      options[:gzip]   = options.fetch :gzip, false
      script_processor.content filename, options
    end

    def stylesheet_digest_filename filename
      stylesheet_processor.digest_filename filename
    end

    def stylesheet_content filename, options = {}
      options[:minify] = options.fetch :minify, false
      options[:gzip]   = options.fetch :gzip, false
      stylesheet_processor.content filename, options
    end

  end

end
