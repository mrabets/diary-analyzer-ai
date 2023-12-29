# frozen_string_literal: true

class ValidateChangeConversationsReceiverIdNullConstraint < ActiveRecord::Migration[7.1]
  def up
    validate_check_constraint :conversations, name: "conversations_receiver_id_null"
    change_column_null :conversations, :receiver_id, false
    remove_check_constraint :conversations, name: "conversations_receiver_id_null"
  end

  def down
    add_check_constraint :conversations, "receiver_id IS NOT NULL", name: "conversations_receiver_id_null",
                                                                    validate: false
    change_column_null :conversations, :receiver_id, true
  end
end
