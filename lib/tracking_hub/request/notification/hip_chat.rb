module TrackingHub
  class Request
    class Notification

      class HipChat
        attr_reader :client, :username, :room, :options

        def send(msg, options = {})
          self.client[self.room].send(self.username, msg, self.options.merge(options))
        end

        private

        attr_writer :client, :username, :room, :options

        def initialize(token, room, username, options = {})
          self.room     = room
          self.username = username
          self.options  = options

          api_version = options.delete(:api_version) || 'v2'

          self.client = ::HipChat::Client.new(token, api_version: api_version)
        end
      end
    end
  end
end
