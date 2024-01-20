# frozen_string_literal: true

require "elasticsearch/model"

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: Rails.env.production? ? ENV.fetch("ELASTICSEARCH_URL") { nil } : "http://localhost:9200",
  log: !Rails.env.production?,
  transport_options: { request: { timeout: 5 } }
)
