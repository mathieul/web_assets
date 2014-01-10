require "logger"

module WebAssets

  module CanLog

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods

      def debug= value
        @debug = value
      end

      def debug?
        @debug
      end

      def logger
        @logger ||= begin
          logger = Logger.new debug? ? "web_assets.log" : STDERR
          logger.level = debug? ? Logger::DEBUG : Logger::ERROR
          logger
        end

      end

    end

  end

end
