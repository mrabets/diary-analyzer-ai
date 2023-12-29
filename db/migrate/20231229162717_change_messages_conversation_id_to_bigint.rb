# frozen_string_literal: true

class ChangeMessagesConversationIdToBigint < ActiveRecord::Migration[7.1]
  def up
    safety_assured { change_column :messages, :conversation_id, :bigint }
  end

  def down
    safety_assured { change_column :messages, :conversation_id, :integer }
  end
end
