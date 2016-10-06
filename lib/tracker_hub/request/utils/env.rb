module TrackerHub
  class Request
    module Utils
      # SimpleDelegator wrapping class for rack environment
      class Env < SimpleDelegator
        # Should the request tracker log the current request
        #
        # @return [Boolean] true if should track the current request,
        #                     false if should not track the current request
        #
        # @example
        #   > new_env = Utils::Env.new(env)
        #   > new_env.trackable?
        #
        # @api public
        def trackable?
          '/assets' != self['SCRIPT_NAME']
        end
      end
    end
  end
end
