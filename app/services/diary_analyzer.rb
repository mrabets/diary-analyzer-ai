# frozen_string_literal: true

class DiaryAnalyzer
  extend Dry::Initializer
  include Dry.Types()

  option :post, type: Types.Instance(Post)
  option :user, type: Types.Instance(User)

  def self.call(post:, user:)
    new(post:, user:).call
  end

  def call
    check_premium_user!
    check_analysis_response!

    @analysis_result_text = analysis_result.dig("choices", 0, "text")
    post.update!(data: { analyze_result: analyze_info })
  end

  private

  attr_reader :post, :user

  def check_premium_user!
    raise PremiumNotFoundError, I18n.t("posts.analyze.premium_not_found") unless user.subscription&.premium?
  end

  def check_analysis_response!
    raise AnalysisError, analysis_result_response.error.message unless analysis_result_response.ok?
  end

  def analysis_result
    analysis_result_response.get
  end

  def analysis_result_response
    @analysis_result_response ||= open_ai_api_client.analyze_diary
  end

  def open_ai_api_client
    OpenAi::ApiClient.new(diary_text:)
  end

  def diary_text
    post.content.to_plain_text.squish
  end

  def analysis_result_parts
    analysis_result_text.split(/\n\d\.\s*/).reject(&:empty?)
  end

  def analyze_info
    @analyze_info ||= analysis_result_parts.each_with_object({}) do |part, info|
      section_regex.each do |key, regex|
        info[key] = send(:"extract_#{key}", part) if part.match?(regex)
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

  def analysis_result_text
    @analysis_result_text ||= analysis_result.dig("choices", 0, "text")
  end
end
