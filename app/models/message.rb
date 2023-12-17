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
  belongs_to :conversation
  belongs_to :user

  after_create_commit { ChatChannel.broadcast_to(conversation, self) }
end
