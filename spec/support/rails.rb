require 'active_support/cache'
require 'active_support/notifications'

module Rails
  @@cache = ActiveSupport::Cache::MemoryStore.new

  class << self
    def env
      'test'
    end

    def cache
      @@cache
    end
  end
end
