require_relative 'notification/hip_chat'

module TrackerHub
  class Request

    class Notification
      KEY_CACHE = 'trackinghub_request_notification'.freeze

      attr_reader :notifier, :timelapse, :options

      def notify(message, args = {})
        return unless self.notifier

        timelapser do
          case self.notifier
          when Notification::HipChat
            self.notifier.send(message, self.options.merge(args))
          end
        end
      end

      private

      attr_writer :notifier, :timelapse, :options

      def initialize(notifier = nil, args = {})
        defaults = {
          notify: true
        }

        self.notifier  = notifier
        self.timelapse = args.delete(:timelapse)
        self.options   = defaults.merge(args)
      end

      def timelapser(&block)
        return block.call unless self.timelapse

        Rails.cache.fetch(KEY_CACHE, expires_in: self.timelapse) do
          block.call
        end
      end
    end
  end
end
