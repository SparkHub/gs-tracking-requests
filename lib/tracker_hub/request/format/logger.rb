module TrackerHub
  class Request
    module Format
      # Logger module formatting and rendering the request object
      module Logger
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
            response:        cleaned_env,
            app_version:     Request.config.app_version,
            tracker_version: Request::VERSION
          }.to_json
        end

        # Extract the rack env keys (see TrackerHub::Request::Config#required_keys)
        #   and convert them
        #
        # @return [Utils::Env] cleaned rack env object
        #
        # @example
        #   > status, headers, body = @app.call(env)
        #   > track = TrackerHub::Request.new(env, status, headers)
        #   > track.cleaned_env
        #
        # @api public
        def cleaned_env
          response.slice(*Request.config.required_keys).merge(serialized_env)
        end

        # Serialize objects before jsonifying them
        #
        # @return [Hash]
        #
        # @example
        #   > status, headers, body = @app.call(env)
        #   > track = TrackerHub::Request.new(env, status, headers)
        #   > track.serialized_env
        #
        # @api public
        #
        # rubocop:disable AbcSize
        def serialized_env
          {
            'action_dispatch.logger' => response['action_dispatch.logger'].formatter.session_info,
            'action_dispatch.remote_ip'   => response['action_dispatch.remote_ip'].to_s,
            'rack.session'                => response['rack.session'].try(:to_hash),
            'rack.session.options'        => response['rack.session.options'].try(:to_hash),
            'http_accept_language.parser' => response['http_accept_language.parser'].header
          }
        end
        # rubocop:enable AbcSize
      end
    end
  end
end
