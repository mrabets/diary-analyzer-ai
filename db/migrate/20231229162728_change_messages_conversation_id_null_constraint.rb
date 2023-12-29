# frozen_string_literal: true

class ChangeMessagesConversationIdNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :messages, "conversation_id IS NOT NULL", name: "messages_conversation_id_null",
                                                                   validate: false
  end
end
