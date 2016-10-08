module TrackerHub
  class Request
    class Notification
      # Service to send notifications to when an error occured during the log process
      class HipChat
        # HipChat API version to call by default
        API_VERSION = 'v2'.freeze

        # Send a notification message
        #
        # @param  [String] msg  Message to send
        # @param  [Hash]   args See more options at
        #                         https://www.hipchat.com/docs/apiv2/method/send_room_notification
        # @return [Boolean]
        #
        # @example
        #   > notifier = TrackerHub::Request::Notification::HipChat.new(token, 'room', 'username')
        #   > notifier.send_message('my message')
        #
        # @api public
        def send_message(msg, args = {})
          client[room].send(username, msg, options.merge(args))
        end

        private

        # @return [HipChat::Client] the hipchat client
        # @api private
        attr_accessor :client

        # @return [String] user's name sending the message
        # @api private
        attr_accessor :username

        # @return [String] room's name to send the message to
        # @api private
        attr_accessor :room

        # @return [Hash] hipchat send method options
        # @api private
        attr_accessor :options

        # Instantiate a HipChat notifier. For more options, please checkout
        #   https://www.hipchat.com/docs/apiv2/method/send_room_notification
        #
        # @param  [String] token API key to talk with hipchat services
        # @param  [String] room  Room's name to send the message
        # @param  [String] username User's name sending the message
        # @option options [String] :api_version Version of the hipchat API
        # @return [TrackerHub::Request::Notification::HipChat]
        #
        # @example
        #   > TrackerHub::Request::Notification::HipChat.new(token, 'room', 'username')
        #
        # @api private
        def initialize(token, room, username, options = {})
          api_version = options.delete(:api_version) || API_VERSION

          self.room     = room
          self.username = username
          self.options  = options

          self.client = ::HipChat::Client.new(token, api_version: api_version)
        end
      end
    end
  end
end
