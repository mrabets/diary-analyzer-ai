# frozen_string_literal: true

class ChangeConversationsSenderIdNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :conversations, "sender_id IS NOT NULL", name: "conversations_sender_id_null", validate: false
  end
end
