module WebAssets

  class Gzipper

    def self.compress content
      stream = StringIO.new
      gz = Zlib::GzipWriter.new stream, Zlib::BEST_COMPRESSION
      gz.write content
      gz.close
      stream.string
    end

    def self.uncompress zipped
      stream = StringIO.new zipped
      gz = Zlib::GzipReader.new stream
      content = gz.read
      gz.close
      content
    end

  end

end
