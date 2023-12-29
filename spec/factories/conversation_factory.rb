# frozen_string_literal: true

# == Schema Information
#
# Table name: conversations
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint           not null
#  sender_id   :bigint           not null
#
# Indexes
#
#  index_conversations_on_sender_id_and_receiver_id  (sender_id,receiver_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
FactoryBot.define do
  factory :conversation, class: "Conversation" do
    association :sender, factory: :user, strategy: :build
    association :receiver, factory: :user, strategy: :build

    trait :with_messages do
      after(:create) do |conversation|
        create_list(:message, 3, conversation:)
      end
    end
  end
end
