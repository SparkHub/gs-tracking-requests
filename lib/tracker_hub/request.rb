require 'logging'

require_relative 'request/version'
require_relative 'request/middleware'
require_relative 'request/setup'

module TrackerHub
  class Request
    extend  Setup
    include Format::Logger::InstanceMethods

    private

    # @return [Hash] the rack environment object built from the response object
    # @api private
    attr_accessor :response

    # @return [Integer] the request status (can be a Fixnum)
    # @api private
    attr_accessor :status

    # @return [Hash] request header
    # @api private
    attr_accessor :request

    # Instantiate a request tracker object.
    #
    # @param [Hash]    env     Rack environement object (full response)
    # @param [Integer] status  Request status
    # @param [Hash]    headers Request header
    #
    # @example
    #   > status, headers, body = @app.call(env)
    #   > TrackerHub::Request.new(env, status, headers)
    #
    # @api private
    def initialize(env, status, headers)
      self.request  = headers
      self.status   = status
      self.response = env
    end
  end
end
