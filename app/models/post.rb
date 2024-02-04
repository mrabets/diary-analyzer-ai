# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  data       :text
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  include Searchable

  validates :title, :content, presence: true
  validates :title, length: { minimum: 2, maximum: 200 }

  has_rich_text :content
  db_belongs_to :user

  serialize :data, coder: YAML, type: Hash

  before_save :reset_analyze_result, if: :content_changed?

  private

  def reset_analyze_result
    data[:analyze_result] = nil
  end

  def content_changed?
    content.body_changed?
  end
end
