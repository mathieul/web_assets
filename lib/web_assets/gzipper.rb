module WebAssets

  class Gzipper

    def self.compress content
      stream = StringIO.new
      gz = Zlib::GzipWriter.new stream, Zlib::BEST_COMPRESSION
      gz.write content
      gz.close
      stream.string
    end

  end

end
