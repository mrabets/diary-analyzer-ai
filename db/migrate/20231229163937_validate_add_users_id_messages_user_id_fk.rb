# frozen_string_literal: true

class ValidateAddUsersIdMessagesUserIdFk < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :messages, :users
  end
end
