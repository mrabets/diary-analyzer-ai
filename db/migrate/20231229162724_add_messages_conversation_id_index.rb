# frozen_string_literal: true

class AddMessagesConversationIdIndex < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :messages, ["conversation_id"], name: :index_messages_conversation_id, algorithm: :concurrently
  end
end
