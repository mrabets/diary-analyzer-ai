# frozen_string_literal: true

class ChangeMessagesUserIdNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :messages, "user_id IS NOT NULL", name: "messages_user_id_null", validate: false
  end
end
