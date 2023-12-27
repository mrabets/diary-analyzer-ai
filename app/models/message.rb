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
class Message < ApplicationRecord
  belongs_to :conversation, class_name: "Conversation"
  belongs_to :user, class_name: "User"

  validates :body, presence: true, allow_blank: false, length: { maximum: 10_000 }

  after_create_commit -> { broadcast_append_to "messages" }
end
