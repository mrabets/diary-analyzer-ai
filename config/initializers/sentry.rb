# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = "https://dc74a16f2d5fed59d559a6ac3c6fb4de@o4504524572262400.ingest.us.sentry.io/4506971546714112"
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
