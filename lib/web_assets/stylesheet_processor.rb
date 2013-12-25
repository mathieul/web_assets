require "compass"
require "sass/plugin"
require "fileutils"
require "web_assets/gzipper"

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
      content = case
      when File.exists?("#{filepath}.css")
        File.read "#{filepath}.css"
      when File.exists?("#{filepath}.scss")
        render_sass_file filepath, :scss, render_options(options)
      when File.exists?("#{filepath}.sass")
        render_sass_file filepath, :sass, render_options(options)
      else
        ""
      end
      options[:gzip] ? Gzipper.compress(content) : content
    end

    def digest_filename filename
    end

    private

    def full_path filename
      File.join source_path, filename
    end

    def render_options options
      {
        style: options[:minify] ? :compressed : :nested
      }
    end

    def render_sass_file filepath, syntax, options
      sass_filename = "#{filepath}.#{syntax}"
      sass_options = compiler.sass_options.merge(
        filename: sass_filename,
        css_filename: "#{File.basename filepath}.css",
        syntax: syntax,
        cache: false
      ).merge(options)
      engine = Sass::Engine.new open(sass_filename).read, sass_options
      engine.to_css
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
