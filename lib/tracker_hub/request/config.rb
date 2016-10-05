require_relative 'config/env_keys'
require_relative 'config/logger'
require_relative 'format/logger'
require_relative 'notification'

module TrackerHub
  class Request

    class Config

      # @return [undefined] logger object to log the request data with
      # @api public
      attr_accessor :logger

      # @return [Array<String>] rack env keys to log
      # @api public
      attr_accessor :required_keys

      # @return [TrackerHub::Request::Notification] service to send a
      #   notification to if request log process fails
      # @api public
      attr_accessor :notification

      # @return [String] version of the application logging the request data
      # @api public
      attr_accessor :app_version

      private

      # Instanciate a Config object with default values
      #
      # @todo Extract logger logic to be able to store data in another way
      #   (ex: database)
      #
      # @return [TrackerHub::Request::Config]
      #
      # @example
      #   > TrackerHub::Request::Config.new
      #
      # @api private
      def initialize
        self.app_version   = ''
        self.logger        = Logger.default_config
        self.required_keys = EnvKeys.default_config
        self.notification  = Request::Notification.new
      end
    end
  end
end
