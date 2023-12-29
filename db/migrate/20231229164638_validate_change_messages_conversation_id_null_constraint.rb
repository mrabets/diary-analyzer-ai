# frozen_string_literal: true

class ValidateChangeMessagesConversationIdNullConstraint < ActiveRecord::Migration[7.1]
  def up
    validate_check_constraint :messages, name: "messages_conversation_id_null"
    change_column_null :messages, :conversation_id, false
    remove_check_constraint :messages, name: "messages_conversation_id_null"
  end

  def down
    add_check_constraint :messages, "conversation_id IS NOT NULL", name: "messages_conversation_id_null",
                                                                   validate: false
    change_column_null :messages, :conversation_id, true
  end
end
