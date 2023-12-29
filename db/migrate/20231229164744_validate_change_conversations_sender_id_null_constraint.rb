# frozen_string_literal: true

class ValidateChangeConversationsSenderIdNullConstraint < ActiveRecord::Migration[7.1]
  def up
    validate_check_constraint :conversations, name: "conversations_sender_id_null"
    change_column_null :conversations, :sender_id, false
    remove_check_constraint :conversations, name: "conversations_sender_id_null"
  end

  def down
    add_check_constraint :conversations, "sender_id IS NOT NULL", name: "conversations_sender_id_null", validate: false
    change_column_null :conversations, :sender_id, true
  end
end
