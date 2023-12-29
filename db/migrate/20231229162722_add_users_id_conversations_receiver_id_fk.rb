# frozen_string_literal: true

class AddUsersIdConversationsReceiverIdFk < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :conversations, :users, column: :receiver_id, primary_key: :id, validate: false
  end
end
