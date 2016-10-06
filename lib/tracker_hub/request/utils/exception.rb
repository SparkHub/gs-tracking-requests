module TrackerHub
  class Request
    module Utils
      # SimpleDelegator wrapping class for exceptions
      class Exception < SimpleDelegator
        # Send a report of the exception with a given notification
        #
        # @param  [TrackerHub::Request::Notification] notification See in request/notification
        #   for a full list of available notifiers
        # @param  [undefined] framework Used framework to retreive the rack environment
        # @return [Boolean]
        #
        # @example
        #   > notifier = TrackerHub::Request::Notification::HipChat.new(token, 'room', 'username')
        #   > notification = TrackerHub::Request::Notification.new(notifier)
        #   > new_exception = Utils::Exception.new(exception)
        #   > new_exception.report(notification)
        #
        # @api public
        def report(notification, framework = Rails)
          formatted_backtrace = backtrace.join("\n")
          msg                 = "[#{framework.env}]\n#{message}\n#{formatted_backtrace}"
          notification.notify(msg)
        end
      end
    end
  end
end
