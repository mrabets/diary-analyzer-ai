# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
FactoryBot.define do
  factory :post, class: "Post" do
    association :user, strategy: :build

    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
  end
end
