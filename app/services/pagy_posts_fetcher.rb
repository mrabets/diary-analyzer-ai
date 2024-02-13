# frozen_string_literal: true

class PagyPostsFetcher
  def self.call(search_query: nil)
    new(search_query).call
  end

  def initialize(search_query)
    @search_query = search_query
  end

  def call
    posts = search_query.present? ? Post.search(search_query) : Post.all
    posts.order(created_at: :desc)
  end

  private

  attr_reader :search_query
end
