module TrackerHub
  class Request
    class Config
      # Rack environment keys to log
      module EnvKeys
        class << self
          # Rack env keys to extract and log
          #
          # @return [Array<String>]
          #
          # @example
          #   > TrackerHub::Request::Config::EnvKeys.default_config
          #
          # @api public
          def default_config
            root_keys + rack_keys + action_dispatch_keys
          end

          private

          # Request keys in the rack env
          #
          # @return [Array<String>]
          #
          # @api private
          def root_keys
            %w(GATEWAY_INTERFACE PATH_INFO QUERY_STRING REMOTE_ADDR REMOTE_HOST REQUEST_METHOD
               REQUEST_URI SCRIPT_NAME SERVER_NAME SERVER_PORT SERVER_PROTOCOL SERVER_SOFTWARE
               HTTP_HOST HTTP_CONNECTION HTTP_UPGRADE_INSECURE_REQUESTS HTTP_USER_AGENT HTTP_ACCEPT
               HTTP_ACCEPT_ENCODING HTTP_ACCEPT_LANGUAGE HTTP_COOKIE HTTP_VERSION REQUEST_PATH
               ORIGINAL_FULLPATH ORIGINAL_SCRIPT_NAME)
          end

          # Rack keys in the rack env
          #
          # @return [Array<String>]
          #
          # @api private
          def rack_keys
            %w(version multithread multiprocess run_once url_scheme hijack? hijack_io
               timestamp request.query_string request.query_hash request.cookie_hash
               request.cookie_string).map do |key|
                 "rack.#{key}"
               end
          end

          # Action dispatch keys in the rack env
          #
          # @return [Array<String>]
          #
          # @api private
          def action_dispatch_keys
            bases = %w(parameter_filter redirect_filter secret_token secret_key_base show_exceptions
                       show_detailed_exceptions http_auth_salt signed_cookie_salt
                       encrypted_cookie_salt encrypted_signed_cookie_salt cookies_serializer
                       cookies_digest request_id).map do |key|
                         "action_dispatch.#{key}"
                       end

            requests = %w(path_parameters content_type request_parameters query_parameters
                          parameters formats unsigned_session_cookie).map do |key|
                            "action_dispatch.request.#{key}"
                          end

            bases + requests
          end
        end
      end
    end
  end
end
