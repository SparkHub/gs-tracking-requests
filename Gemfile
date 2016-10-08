source 'https://rubygems.org'

# Specify your gem's dependencies in tracker_hub-requests.gemspec
gemspec

group :development, :test do
  gem 'rubocop', require: false
  gem 'brakeman', require: false
  if RUBY_VERSION >= '2.1.0'
    gem 'reek', require: false
  else
    gem 'reek', '~> 3.11', require: false
  end
end

group :test do
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false if RUBY_VERSION >= '2.0'
end
