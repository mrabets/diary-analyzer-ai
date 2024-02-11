# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  data       :jsonb            not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_data     (data) USING gin
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

describe Post do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(200) }
    it { is_expected.to validate_presence_of(:content) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_rich_text(:content) }
  end

  describe "search" do
    subject(:search) { described_class.search(query) }

    let(:posts) { create_list(:post, 3) }
    let(:query) { "query" }
    let(:search_params) do
      {
        query: {
          multi_match: {
            query:,
            fields: %w[title content]
          }
        }
      }
    end
    let(:elastic_search) { instance_double(Elasticsearch::Model::Response::Response, records: posts) }

    before do
      allow(described_class.__elasticsearch__).to receive(:search).with(search_params).and_return(elastic_search)
    end

    it "returns posts with matching title" do
      expect(search).to eq(posts)
    end
  end

  describe "as_indexed_json" do
    subject(:as_indexed_json) { post.as_indexed_json }

    let(:post) { create(:post) }
    let(:expected_json) do
      {
        id: post.id,
        title: post.title,
        content: post.content.to_plain_text
      }.with_indifferent_access
    end

    it "returns post as json" do
      expect(as_indexed_json.with_indifferent_access).to include(expected_json.with_indifferent_access)
    end
  end

  describe "callbacks" do
    describe "before_save" do
      let(:post) { build(:post, data:) }
      let(:data) do
        {
          analyze_result: {
            emotions: ["happy"],
            keywords: %w[happy job],
            recommendations: ["Smile. Find a new job.", "Go to specialist"]
          }
        }
      end

      it "resets analyze result if content changed" do
        post.content.body = "new content"
        post.save

        expect(post.data[:analyze_result]).to be_nil
      end
    end
  end
end
