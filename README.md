[![Code Climate](https://codeclimate.com/github/SparkHub/gs-tracking-requests/badges/gpa.svg)](https://codeclimate.com/github/SparkHub/gs-tracking-requests)
[![Test Coverage](https://codeclimate.com/github/SparkHub/gs-tracking-requests/badges/coverage.svg)](https://codeclimate.com/github/SparkHub/gs-tracking-requests/coverage)

# TrackerHub::Request

Part of __TrackerHub__, __Request__ is a gem tracking every requests on the backend side. Some keys will be filtered and the request data will finally be saved into a logfile. This logfile will be automatically managed and rotated by the [logging](https://github.com/TwP/logging) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tracker_hub-request', git: 'git@github.com:SparkHub/gs-tracking-requests.git'
```

And then execute:

    $ bundle

## Configuration _(optional)_

In an initializer, you can configure the tracker:

```ruby
# ./config/initializers/request_tracker.rb
TrackerHub::Request.setup do |config|
  config.app_version   = '1.0'
  config.required_keys = %w(my rack env keys to log)
  config.logger        = ActiveSupport::Logger.new('requests.log')
  config.notification  = TrackerHub::Request::Notification.new(TrackerHub::Request::Notification::HipChat.new('my_token', 'my_room', 'my_username'))
end
```

__Note:__

- __logger__

Here you can define your own configured logger. The default logger is [logging](https://github.com/TwP/logging). Feel free to add your own, or use another gem!

- __notification__

If an error occure, it will be catched and a notification will be sent to the service of your choice. The list of available services are defined [here](https://github.com/SparkHub/gs-tracking-requests/tree/master/lib/tracker_hub/request/notification).

## Usage

Add the middleware to your environment:

```ruby
config.middleware.insert_after ActionDispatch::DebugExceptions, TrackerHub::Request::Middleware
```

Activate the TrackerHub by adding to your environment (or `.env`):

    $ TRACKER=true

Get your request logs:

    $ tail -f ./log/tracker/requests.log

## Running tests

To run tests:

    $ bundle exec rake spec

## Contributing

Bug reports and pull request are welcome on GitHub at https://github.com/SparkHub/gs-tracking-requests. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
