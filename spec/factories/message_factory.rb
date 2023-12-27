# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :integer
#  user_id         :integer
#
FactoryBot.define do
  factory :message, class: "Message" do
    association :conversation, strategy: :build
    association :user, strategy: :build

    body { Faker::Lorem.paragraph }
  end
end
