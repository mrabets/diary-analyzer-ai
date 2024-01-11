# frozen_string_literal: true

require "redis"
require "connection_pool"

module Rails
  class << self
    def redis
      @redis ||= ConnectionPool::Wrapper.new do
        Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379"))
      end
    end
  end
end
