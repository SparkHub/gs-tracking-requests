require_relative 'config'

module TrackerHub
  class Request
    # Configure the request tracker
    module Setup
      # Get the current configuration, instantiate a new object if nil
      #   Note: each attribute can also be written through the config object
      #
      # @return [TrackerHub::Request::Config] configuration object
      #
      # @example
      #   > # get the current configuration
      #   > TrackerHub::Request.config
      #   > => #<TrackerHub::Request::Config:0x007fa574ad7390 ...>
      #   >
      #   > # set a specific value in the config
      #   > TrackerHub::Request.config.app_version = '4.2'
      #
      # @api public
      def config
        @config ||= self::Config.new
      end

      # Setup configuration in block
      #
      # @yield (see TrackerHub::Request::Config#initialize)
      # @return [TrackerHub::Request::Config]
      #
      # @example
      #   > TrackerHub::Request.setup do |config|
      #   >   config.app_version = '4.2'
      #   > end
      #
      # @api public
      def setup
        yield(config)
      end

      private

      # @return [TrackerHub::Request::Config] the tracking request configuration
      # @api private
      attr_writer :config
    end
  end
end
