require "compass"
require "sass/plugin"
require "fileutils"

module WebAssets

  class StylesheetProcessor

    RE_EXTENSION = /\.(css|scss|sass)\z/

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
      filepath = full_path filename.sub(RE_EXTENSION, '')
      case
      when File.exists?("#{filepath}.css")
        File.read "#{filepath}.css"
      when File.exists?("#{filepath}.scss")
        render_sass_file filepath, "scss"
      when File.exists?("#{filepath}.sass")
        render_sass_file filepath, "sass"
      else
        ""
      end
    end

    def digest_filename filename
    end

    private

    def full_path filename
      File.join source_path, filename
    end

    def render_sass_file filepath, extension
      engine = compiler.engine "#{filepath}.#{extension}", "#{File.basename filepath}.css"
      engine.render
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
