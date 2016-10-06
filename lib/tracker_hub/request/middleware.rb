require_relative 'utils/env'
require_relative 'utils/exception'

module TrackerHub
  class Request
    # Middleware to include in a Rails stack to log every incoming requests
    class Middleware
      # Method called by the middleware stack to run the request tracker
      #
      # @param  [Hash]  env Rack env
      # @return [Array]
      #
      # @api public
      def call(env)
        # execute application to get more data (injected into env)
        status, headers, body = @app.call(env)
        # save logs from env
        track(env, status, headers)
        # release the process to other middlewares
        [status, headers, body]
      end

      private

      # Instanciate the request tracker middleware
      #
      # @param  [undefined] app Previous middelware
      # @return [undefined]
      #
      # @api private
      def initialize(app)
        @logger = ::TrackerHub::Request.config.logger
        @app    = app
      end

      # Initiate the request tracker to store formated requests in a log file.
      #   If an internal error occurs while logging the request, and if a
      #   notification has been configured (see TrackerHub::Request::Notification),
      #   then a notification is sent to the configured service
      #
      # @param  [Hash]      env     Rack env
      # @param  [Integer]   status  HTTP request status
      # @param  [Hash]      headers Header of the HTTP request
      # @return [undefined]
      #
      # @example
      #   > status, headers, body = @app.call(env)
      #   > track(env, status, headers)
      #
      # @api private
      def track(env, status, headers)
        new_env = Utils::Env.new(env)
        return unless new_env.trackable?

        @logger.info ::TrackerHub::Request.new(new_env, status, headers).to_logger
      rescue StandardError => exception
        notifier = ::TrackerHub::Request.config.notification
        Utils::Exception.new(exception).report(notifier)
      end
    end
  end
end
