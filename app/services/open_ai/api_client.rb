# frozen_string_literal: true

class OpenAi::ApiClient < Faraday::ApiClient
  include Dry.Types()

  option :diary_text, Types::String, reader: :private

  def analyze_diary
    post("completions", gpt_params)
  end

  private

  delegate :api_key,
           :model,
           :max_tokens,
           :temperature,
           :top_p,
           :frequency_penalty,
           :presence_penalty,
           to: :config

  def gpt_params
    {
      prompt: prepared_prompt,
      model:,
      max_tokens:,
      temperature:,
      top_p:,
      frequency_penalty:,
      presence_penalty:
    }
  end

  def prepared_prompt
    "This is a diary text: '#{diary_text}'.\n\n" \
      "Determine which emotions are predominated," \
      "highlight main keywords from the text and" \
      "give recommendations to improve the mood. Follow the format: \n" \
      "1. Emotions: \n" \
      "2. Keywords: \n" \
      "3. Recommendations: \n"
  end

  def cache
    Digest::SHA256.hexdigest(diary_text)
  end

  def failure_message
    I18n.t("open_ai_api_client.failure_message")
  end
end
