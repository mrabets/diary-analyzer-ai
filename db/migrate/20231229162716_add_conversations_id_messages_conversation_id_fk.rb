# frozen_string_literal: true

class AddConversationsIdMessagesConversationIdFk < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :messages, :conversations, column: :conversation_id, primary_key: :id, validate: false
  end
end
