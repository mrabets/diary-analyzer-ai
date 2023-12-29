# frozen_string_literal: true

class ChangeConversationsSenderIdToBigint < ActiveRecord::Migration[7.1]
  def up
    safety_assured { change_column :conversations, :sender_id, :bigint }
  end

  def down
    safety_assured { change_column :conversations, :sender_id, :integer }
  end
end
