# frozen_string_literal: true

class DiaryAnalyzer
  def self.call(post:, user:)
    new(post:, user:).call
  end

  def initialize(post:, user:)
    @post = post
    @user = user
  end

  def call
    raise PremiumNotFoundError, I18n.t("posts.analyze.premium_not_found") unless user.subscription&.premium?
    raise AnalysisError, analysis_result[:error] if analysis_result[:error]

    @analysis_result_text = analysis_result.dig("choices", 0, "text")

    post.update!(data: analyze_data_to_save)
  end

  private

  attr_reader :post, :user, :analysis_result_text

  def analysis_result
    @analysis_result ||= open_ai_api_client.analyze_diary
  end

  def open_ai_api_client
    OpenAi::ApiClient.new(diary_text:)
  end

  def diary_text
    post.content.to_plain_text.squish
  end

  def analyze_data_to_save
    {
      analyze_result: {
        emotions: analyze_info[:emotions],
        keywords: analyze_info[:keywords],
        recommendations: analyze_info[:recommendations]
      }
    }
  end

  def analysis_result_parts
    analysis_result_text.split(/\n\d\.\s*/).reject(&:empty?)
  end

  def analyze_info
    @analyze_info ||= analysis_result_parts.each_with_object({}) do |part, info|
      case part
      when section_regex[:emotions]
        info[:emotions] = extract_emotions(part)
      when section_regex[:keywords]
        info[:keywords] = extract_keywords(part)
      when section_regex[:recommendations]
        info[:recommendations] = extract_recommendations(part)
      end
    end
  end

  def extract_emotions(part)
    part.gsub(section_regex[:emotions], "").split(",").map(&:strip)
  end

  def extract_keywords(part)
    part.gsub(section_regex[:keywords], "").split(",").map(&:strip)
  end

  def extract_recommendations(part)
    part.gsub(section_regex[:recommendations], "").split("\n").map do |rec|
      rec.gsub(/^\s*-\s*/, "").strip
    end.reject(&:empty?)
  end

  def section_regex
    @section_regex ||= {
      emotions: /emotions:\s*/i,
      keywords: /keywords:\s*/i,
      recommendations: /recommendations:\s*/i
    }
  end
end
