require_relative 'config'

module TrackerHub
  class Request

    module Setup

      def config
        @config ||= self::Config.new
      end

      def setup
        yield(config)
      end

      private

      attr_writer :config
    end
  end
end
