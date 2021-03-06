require_relative 'notification/hip_chat'

module TrackerHub
  class Request
    # Notify a configured service when an error occured during the request log process
    class Notification
      # Key to cache the timelapse between 2 notifications
      KEY_CACHE = 'trackinghub_request_notification'.freeze

      # @return [Object] the notification adapter
      # @api public
      attr_reader :notifier

      # @return [Integer|ActiveSupport::Duration] timelapse between 2 notifications
      # @api public
      attr_reader :timelapse

      # @return [Hash] notification and notifier options
      # @api public
      attr_reader :options

      # Trigger a notification paused by a timelapse if specified
      #
      # @param  [String] message Notification's message
      # @param  [Hash]   args    Notifier adapter's options (if there is any)
      # @return [undefined]
      #
      # @example
      #   > notifier = TrackerHub::Request::Notification::HipChat.new(token, 'room', 'username')
      #   > options = { timelapse: 10.minutes }
      #   > notification = TrackerHub::Request::Notification.new(notifier, options)
      #   > notification.notify('my message')
      #
      # @api public
      def notify(message, args = {})
        timelapser do
          notifier.send_message(message, options.merge(args))
        end
      rescue
        false
      end

      private

      # @return [Object] the notification adapter
      # @api private
      attr_writer :notifier

      # @return [Integer|ActiveSupport::Duration] timelapse between 2 notifications
      # @api private
      attr_writer :timelapse

      # @return [Hash] notification and notifier options
      # @api private
      attr_writer :options

      # Instantiate a notification object to add the ability to send a notification
      #   to any service adapter (see in request/notification). If a timelapse is
      #   given in parameter, there will be a pause between 2 notifications.
      #   Please checkout the available adapters for more :args: options
      #
      # @param       [Object]  notifier   The notification adapter
      # @option args [Integer] :timelapse Time between 2 notifications
      #
      # @example
      #   > notifier = TrackerHub::Request::Notification::HipChat.new(token, 'room', 'username')
      #   > options = { timelapse: 10.minutes }
      #   > TrackerHub::Request::Notification.new(notifier, options)
      #
      # @api private
      def initialize(notifier = nil, args = {})
        defaults = {
          notify: true
        }

        self.notifier  = notifier
        self.timelapse = args.delete(:timelapse)
        self.options   = defaults.merge(args)
      end

      # Execute an action in a timelapse
      #
      # @return [Boolean]
      #
      # @api private
      def timelapser
        return yield unless timelapse

        Rails.cache.fetch(KEY_CACHE, expires_in: timelapse) do
          yield
        end
      end
    end
  end
end
