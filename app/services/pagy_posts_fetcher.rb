# frozen_string_literal: true

class PagyPostsFetcher
  def self.call(search_query:, user:)
    new(search_query, user).call
  end

  def initialize(search_query, user)
    @search_query = search_query
    @user = user
  end

  def call
    posts = search_query.present? ? Post.search(search_query) : Post.all
    posts.order(created_at: :desc).where(user_id: user.id)
  end

  private

  attr_reader :search_query, :user
end
