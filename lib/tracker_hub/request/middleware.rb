module TrackerHub
  class Request

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
        track(env, status, headers) unless do_not_track(env)
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
        begin
          @logger.info ::TrackerHub::Request.new(env, status, headers).to_logger
        rescue StandardError => e
          backtrace = e.backtrace.join("\n")
          msg       = "[#{Rails.env}]\n#{e.message}\n#{backtrace}"
          ::TrackerHub::Request.config.notification.notify(msg)
        end
      end

      # Should the request tracker log the current request
      #
      # @param  [Hash]    env Rack env
      # @return [Boolean]     true if should not track the current request,
      #                         false if should track the current request
      #
      # @api private
      def do_not_track(env)
        env['SCRIPT_NAME'] == '/assets'
      end
    end
  end
end
