# frozen_string_literal: true

module Post::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks unless Rails.env.test?

    settings index: { number_of_shards: 1 } do
      mappings dynamic: "false" do
        indexes :title
        indexes :content, type: "text"
      end
    end
  end

  def as_indexed_json(_options = {})
    as_json(
      include: {
        rich_text_content: { only: :body }
      }
    ).tap do |data|
      data[:content] = content.to_plain_text
    end
  end

  class_methods do
    def search(query)
      params = {
        query: {
          multi_match: {
            query:,
            fields: %w[title content]
          }
        }
      }

      __elasticsearch__.search(params).records
    end
  end
end
