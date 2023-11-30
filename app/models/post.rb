# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  validates :title, :content, presence: true
  validates :title, length: { minimum: 5, maximum: 50 }
  validates :content, length: { minimum: 10, maximum: 1000 }
end
