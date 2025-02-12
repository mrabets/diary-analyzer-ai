# frozen_string_literal: true

class OpenAi::Config < Anyway::Config
  config_name :open_ai

  attr_config(
    :api_key,
    base_url: "https://api.openai.com/v1",
    open_timeout: 3,
    read_timeout: 8,
    write_timeout: 7,
    cache_expires_in: 24.hours,
    cache_refreshes_after: 1.hour,
    rate_threshold: 0.7,
    evaluation_window: 30,
    cool_down: 60,
    model: "gpt-4o",
    max_tokens: 250,
    temperature: 0.3,
    top_p: 1.0,
    frequency_penalty: 0.0,
    presence_penalty: 0.0
  )
end
