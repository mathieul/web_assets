module WebAssets

  class Api

    attr_reader :script_processor, :stylesheet_processor

    def initialize script_processor, stylesheet_processor
      @script_processor     = script_processor
      @stylesheet_processor = stylesheet_processor
    end

    #
    # set the script path and return :ok
    #
    def set_script_path path
      script_processor.set_path path
    end

    #
    # set the stylesheet path and return :ok
    #
    def set_stylesheet_path path
      stylesheet_processor.set_path path
    end

    #
    # append a path to the script load path and return :ok
    #
    def add_script_load_path path
      script_processor.add_load_path path
    end

    #
    # append a path to the stylesheet load path and return :ok
    #
    def add_stylesheet_load_path path
      stylesheet_processor.add_load_path path
    end

    #
    # return an array of the filenames the script filename depends on and itself
    #
    def script_filenames filename
      script_processor.filenames filename
    end

    #
    # return the script filename with its content digest
    #
    def script_digest_filename filename
      script_processor.digest_filename filename
    end

    #
    # return the script content as a string
    # boolean options:
    #   - bundle: inline all dependencies
    #   - minify: minify the content
    #   - gzip:   return the gzipped binary content
    #
    def script_content filename, options = {}
      options[:bundle] = options.fetch :bundle, true
      options[:minify] = options.fetch :minify, false
      options[:gzip]   = options.fetch :gzip, false
      script_processor.content filename, options
    end

    #
    # return the stylesheet filename with its content digest
    #
    def stylesheet_digest_filename filename
      stylesheet_processor.digest_filename filename
    end

    #
    # return the stylesheet content processed, as a string
    # boolean options:
    #   - minify: minify the content
    #   - gzip:   return the gzipped binary content
    #
    def stylesheet_content filename, options = {}
      options[:minify] = options.fetch :minify, false
      options[:gzip]   = options.fetch :gzip, false
      stylesheet_processor.content filename, options
    end

  end

end
