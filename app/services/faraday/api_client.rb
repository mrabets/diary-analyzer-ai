# frozen_string_literal: true

class Faraday::ApiClient
  extend Dry::Initializer

  param :options, default: -> { {} }, reader: :private

  def post(endpoint, params = {})
    perform_request(:post, endpoint, params)
  end

  def get(endpoint, params = {})
    perform_request(:get, endpoint, params)
  end

  private

  DEFAULT_CACHE_KEY = "faraday_api_client"
  private_constant :DEFAULT_CACHE_KEY

  delegate :api_key,
           :base_url,
           :open_timeout,
           :read_timeout,
           :write_timeout,
           :cache_expires_in,
           :cache_refreshes_after,
           :rate_threshold,
           :evaluation_window,
           :cool_down,
           to: :config

  def connection
    @connection ||= Faraday.new(base_url, **faraday_options) do |faraday|
      faraday.headers["Content-Type"] = "application/json"
      faraday.headers["Authorization"] = "Bearer #{api_key}"

      faraday.response :raise_error
      faraday.response :logger, Rails.logger, headers: true, log_level: :debug do |formatter|
        formatter.filter(/(x-api-key:\s*)"\w+(\w{4})"/i, '\1"xxxx\2"')
      end
      faraday.adapter :net_http_persistent
    end
  end

  def faraday_options
    {
      request: {
        open_timeout:,
        read_timeout:,
        write_timeout:
      }
    }.merge!(options)
  end

  def setup_request(request, endpoint, params)
    request.url(endpoint)
    request.body = params.to_json if params.present?
  end

  def config
    @config ||= OpenAi::Config.new
  end

  def circuit
    @circuit ||= Faulty.circuit(
      :open_ai_api,
      cache_expires_in:,
      cache_refreshes_after:,
      rate_threshold:,
      evaluation_window:,
      cool_down:,
      errors: [Faraday::Error]
    )
  end

  def perform_request(method, endpoint, params)
    circuit.try_run(cache:) do
      Retriable.retriable do
        response = connection.public_send(method) do |request|
          setup_request(request, endpoint, params)
        end

        process_response(response)
      end
    end
  end

  def process_response(response)
    JSON.parse(response.body)
  end

  def cache
    DEFAULT_CACHE_KEY
  end
end
