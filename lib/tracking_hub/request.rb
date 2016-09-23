require 'logging'

require_relative 'request/version'
require_relative 'request/middleware'
require_relative 'request/setup'

module TrackingHub
  class Request
    extend  Setup
    include Format::Logger::InstanceMethods

    private

    attr_accessor :response, :status, :request

    def initialize(env, status, headers)
      self.request  = headers
      self.status   = status
      self.response = env
    end
  end
end
