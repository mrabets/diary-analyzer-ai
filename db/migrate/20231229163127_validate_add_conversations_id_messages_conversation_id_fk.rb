# frozen_string_literal: true

class ValidateAddConversationsIdMessagesConversationIdFk < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :messages, :conversations
  end
end
