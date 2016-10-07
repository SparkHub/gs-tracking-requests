module Factory

  class << self

    def notification(notifier = nil, args = {})
      TrackerHub::Request::Notification.new(notifier, args)
    end
  end
end
