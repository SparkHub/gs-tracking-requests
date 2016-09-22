require_relative 'config/env_keys'
require_relative 'config/logger'
require_relative 'format/logger'
require_relative 'notification'

module TrackingHub
  class Request

    class Config

      attr_accessor :logger, :required_keys, :notification, :app_version

      private

      def initialize
        self.app_version   = ''
        self.logger        = Logger.default_config
        self.required_keys = EnvKeys.default_config
        self.notification  = Request::Notification.new
      end
    end
  end
end
