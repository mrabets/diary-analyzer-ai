# frozen_string_literal: true

module PostsHelper
  include Pagy::Frontend

  def emotions(post)
    post.data.dig(:analyze_result, :emotions)&.join(", ")
  end

  def keywords(post)
    post.data.dig(:analyze_result, :keywords)&.join(", ")
  end

  def recommendations(post)
    post.data.dig(:analyze_result, :recommendations)&.join(", ")
  end
end
