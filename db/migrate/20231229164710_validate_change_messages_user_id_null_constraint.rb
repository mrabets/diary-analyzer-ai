# frozen_string_literal: true

class ValidateChangeMessagesUserIdNullConstraint < ActiveRecord::Migration[7.1]
  def up
    validate_check_constraint :messages, name: "messages_user_id_null"
    change_column_null :messages, :user_id, false
    remove_check_constraint :messages, name: "messages_user_id_null"
  end

  def down
    add_check_constraint :messages, "user_id IS NOT NULL", name: "messages_user_id_null", validate: false
    change_column_null :messages, :user_id, true
  end
end
