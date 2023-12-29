# frozen_string_literal: true

class AddUsersIdMessagesUserIdFk < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :messages, :users, column: :user_id, primary_key: :id, validate: false
  end
end
