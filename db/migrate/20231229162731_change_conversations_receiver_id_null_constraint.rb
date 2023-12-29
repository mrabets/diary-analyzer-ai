# frozen_string_literal: true

class ChangeConversationsReceiverIdNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :conversations, "receiver_id IS NOT NULL", name: "conversations_receiver_id_null",
                                                                    validate: false
  end
end
