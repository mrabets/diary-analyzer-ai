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
FactoryBot.define do
  factory :post, class: "Post" do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
  end
end
