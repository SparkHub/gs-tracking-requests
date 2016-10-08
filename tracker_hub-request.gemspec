# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tracker_hub/request/version'

Gem::Specification.new do |spec|
  spec.name          = 'tracker_hub-request'
  spec.version       = TrackerHub::Request::VERSION
  spec.authors       = ['Maxime Chaisse-Leal']
  spec.email         = ['maxime.chaisseleal@gmail.com']

  spec.summary       = 'Track all the incoming requests and store them in log files.'
  spec.description   = 'Track all the incoming requests and store them in log files.'
  spec.homepage      = 'https://github.com/SparkHub/gs-tracking-request'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'logging', '~> 2.1'
  spec.add_dependency 'hipchat', '~> 1.5'

  if RUBY_VERSION >= '2.2.2'
    spec.add_dependency 'activesupport'
  else
    spec.add_dependency 'activesupport', '< 5'
  end

  spec.add_development_dependency 'bundler',   '~> 1.13'
  spec.add_development_dependency 'rake',      '~> 11.3'
  spec.add_development_dependency 'rspec',     '~> 3.0'

  if RUBY_VERSION >= '2.2.2'
    spec.add_development_dependency 'rack'
  else
    spec.add_development_dependency 'rack', '~> 1.6'
  end
end
