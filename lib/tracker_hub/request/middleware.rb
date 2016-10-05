module TrackerHub
  class Request

    class Middleware

      def initialize(app)
        @logger = ::TrackerHub::Request.config.logger
        @app    = app
      end

      def call(env)
        # execute application to get more data (injected into env)
        status, headers, body = @app.call(env)
        # save logs from env
        track(env, status, headers) unless do_not_track(env)
        # release the process to other middlewares
        [status, headers, body]
      end

      private

      def track(env, status, headers)
        begin
          @logger.info ::TrackerHub::Request.new(env, status, headers).to_logger
        rescue StandardError => e
          msg = "[#{Rails.env}]\n#{e.message}\n#{e.backtrace.join('\n')}"
          ::TrackerHub::Request.config.notification.notify(msg)
        end
      end

      def do_not_track(env)
        env['SCRIPT_NAME'] == '/assets'
      end
    end
  end
end
