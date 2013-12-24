module DynamoAssets

  class Api

    attr_reader :script_processor, :stylesheet_processor

    def initialize script_processor, stylesheet_processor
      @script_processor     = script_processor
      @stylesheet_processor = stylesheet_processor
    end

    def append_script_path path
      script_processor.append_path path
    end

    def append_stylesheet_path path
      stylesheet_processor.append_path path
    end

    def script_files file_name
      script_processor.files file_name
    end

    def script_content file_name, options = {}
      options[:bundle] = options.fetch :bundle, true
      options[:minify] = options.fetch :minify, false
      options[:gzip]   = options.fetch :gzip, false
      script_processor.content file_name, options
    end

    def stylesheet_content file_name, options = {}
      options[:minify] = options.fetch :minify, false
      options[:gzip]   = options.fetch :gzip, false
      stylesheet_processor.content file_name, options
    end

  end

end
