require 'hipchat'
require 'factories/token'
require 'factories/sequence'

module Factory

  class << self

    def hip_chat(args = {})
      token     = args.delete(:token)     || Factory.token
      room      = args.delete(:room)      || Factory.sequence { |n| "room#{n}" }
      username  = args.delete(:username)  || Factory.sequence { |n| "username#{n}" }
      TrackerHub::Request::Notification::HipChat.new(token, room, username, args)
    end
  end
end
