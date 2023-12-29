# frozen_string_literal: true

class AddMessagesUserIdIndex < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :messages, ["user_id"], name: :index_messages_user_id, algorithm: :concurrently
  end
end
