# frozen_string_literal: true

Faulty.init do |config|
  config.cache = Faulty::Cache::Rails.new(
    ActiveSupport::Cache::RedisCacheStore.new
  )
end
