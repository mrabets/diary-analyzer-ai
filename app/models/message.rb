# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_messages_conversation_id  (conversation_id)
#  index_messages_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#  fk_rails_...  (user_id => users.id)
#
class Message < ApplicationRecord
  belongs_to :conversation, class_name: "Conversation"
  belongs_to :user, class_name: "User"

  validates :body, presence: true, allow_blank: false, length: { maximum: 10_000 }

  after_create_commit -> { broadcast_append_to "messages" }
end
