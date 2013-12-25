require "compass"
require "sass/plugin"
require "fileutils"

module WebAssets

  class StylesheetProcessor

    attr_reader :source_path

    def initialize
      Sass.load_paths.clear
    end

    def set_path path
      return [:error, "#{path} isn't an existing directory."] unless Dir.exists? path
      @source_path = path
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

    def content filename, options
      name = File.basename(filename).gsub /\.(s[ac]ss)$/, ''
      css_path = full_path "#{name}.css"
      File.read css_path if File.exists? css_path
      engine = compiler.engine sass_file(css_path), "#{name}.css"
      engine.render
    end

    private

    def full_path filename
      File.join source_path, filename
    end

    def sass_file css_path
      path = css_path.gsub /\.css/, ''
      candidate = "#{path}.scss"
      return candidate if File.exists? candidate
      "#{path}.sass"
    end

    def compiler
      @compiler ||= Compass::Compiler.new(
        tmp_path,
        source_path,
        destination_path,
        sass: Compass.sass_engine_options
      )
    end

    def tmp_path
      @tmp_path ||= File.join(Dir.pwd, "tmp").tap do |path|
        FileUtils.mkdir path unless Dir.exists? path
      end
    end

    def destination_path
      File.join(tmp_path, "css").tap do |path|
        FileUtils.mkdir path unless Dir.exists? path
      end
    end

  end

end
