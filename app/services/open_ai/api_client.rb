# frozen_string_literal: true

class OpenAi::ApiClient < Faraday::ApiClient
  include Dry.Types()

  option :diary_text, Types::String, reader: :private

  def analyze_diary
    post("completions", gpt_params)
  end

  private

  delegate :model,
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
    <<~PROMPT
      This is a diary text: '#{diary_text}'.

      Determine which emotions are predominated, highlight main keywords from the text and give recommendations to improve the mood. Follow the format:
      1. Emotions:
      2. Keywords:
      3. Recommendations:
    PROMPT
  end

  def cache
    "diary_analysis_#{Digest::SHA256.hexdigest(diary_text)}"
  end
end
