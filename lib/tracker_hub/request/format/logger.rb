module TrackerHub
  class Request
    module Format

      module Logger

        module InstanceMethods

          # Format the response to the logger
          #
          # @return [JSON]
          #
          # @example
          #   > status, headers, body = @app.call(env)
          #   > track = TrackerHub::Request.new(env, status, headers)
          #   > track.to_logger
          #
          # @api public
          def to_logger
            {
              status:          status,
              request:         request,
              response:        Logger.clean_env(response),
              app_version:     Request.config.app_version,
              tracker_version: Request::VERSION
            }.to_json
          end
        end

        private

        class << self

          # Extract the rack env keys (see TrackerHub::Request::Config#required_keys)
          #   and convert them
          #
          # @return [Hash] cleaned rack env object
          #
          # @api private
          def clean_env(env)
            env.slice(*Request.config.required_keys).tap do |new_env|
              new_env['action_dispatch.logger']      = env['action_dispatch.logger'].formatter.session_info
              new_env['action_dispatch.remote_ip']   = env['action_dispatch.remote_ip'].to_s
              new_env['rack.session']                = env['rack.session'].try(:to_hash)
              new_env['rack.session.options']        = env['rack.session.options'].try(:to_hash)
              new_env['http_accept_language.parser'] = env['http_accept_language.parser'].header
            end
          end
        end
      end
    end
  end
end
