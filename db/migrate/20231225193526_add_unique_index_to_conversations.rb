# frozen_string_literal: true

class AddUniqueIndexToConversations < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :conversations, %i[sender_id receiver_id], unique: true, algorithm: :concurrently
  end
end
