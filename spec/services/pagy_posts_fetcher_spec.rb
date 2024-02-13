# frozen_string_literal: true

require "rails_helper"

describe PagyPostsFetcher do
  describe ".call" do
    subject(:call) { described_class.call(search_query:) }

    let(:search_query) { "search_query" }

    let!(:posts) { create_list(:post, 3) + searched_posts }
    let(:searched_posts) { create_list(:post, 2) }
    let(:posts_relation) { Post.where(id: posts.pluck(:id)) }
    let(:searched_posts_relation) { Post.where(id: searched_posts.pluck(:id)) }

    before do
      allow(Post).to receive(:search).with(search_query).and_return(searched_posts_relation)
      allow(Post).to receive(:all).and_return(posts_relation)
    end

    context "when search_query is present" do
      it "returns searched posts" do
        expect(call).to eq(searched_posts_relation.order(created_at: :desc))

        expect(Post).to have_received(:search)
      end
    end

    context "when search_query is not present" do
      let(:search_query) { nil }

      it "returns all posts" do
        expect(call).to eq(posts_relation.order(created_at: :desc))
      end
    end
  end
end
