# frozen_string_literal: true

require "rails_helper"

describe PagyPostsFetcher do
  include_context "user"

  describe ".call" do
    subject(:call) { described_class.call(search_query:, user:) }

    let(:search_query) { "search_query" }

    let!(:posts) { create_list(:post, 3, user_id: user.id) + searched_posts }
    let(:searched_posts) { create_list(:post, 2, user_id: user.id) }
    let(:posts_relation) { Post.where(id: posts.pluck(:id)) }
    let(:searched_posts_relation) { Post.where(id: searched_posts.pluck(:id)) }

    before do
      allow(Post).to receive(:search).with(search_query).and_return(searched_posts_relation)
      allow(Post).to receive(:all).and_return(posts_relation)
    end

    context "when search_query is present" do
      it "returns searched posts" do
        expect(call).to include(*searched_posts)

        expect(Post).to have_received(:search)
      end
    end

    context "when search_query is not present" do
      let(:search_query) { nil }

      it "returns all posts" do
        expect(call).to include(*posts)
      end
    end
  end
end
