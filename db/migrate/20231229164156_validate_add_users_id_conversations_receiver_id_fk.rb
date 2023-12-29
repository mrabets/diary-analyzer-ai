# frozen_string_literal: true

class ValidateAddUsersIdConversationsReceiverIdFk < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :conversations, :users
  end
end
