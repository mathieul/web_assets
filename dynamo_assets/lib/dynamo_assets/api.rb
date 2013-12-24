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

    def script_content file_name
      script_processor.content file_name
    end

    def stylesheet_content file_name
      stylesheet_processor.content file_name
    end

  end

end
