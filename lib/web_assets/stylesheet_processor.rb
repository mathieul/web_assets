require "compass"
require "sass/plugin"

module WebAssets

  class StylesheetProcessor

    attr_reader :path

    def initialize
      Sass.load_paths.clear
    end

    def set_path path
      return [:error, "#{path} isn't an existing directory."] unless Dir.exists? path
      @path = path
      :ok
    end

    def add_load_path path
      return [:error, "#{path} isn't an existing directory."] unless Dir.exists? path
      Sass.load_paths << path
      :ok
    end

    def paths
      Sass.load_paths.dup
    end

  end

end
