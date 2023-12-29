# frozen_string_literal: true

class ChangeConversationsReceiverIdToBigint < ActiveRecord::Migration[7.1]
  def up
    safety_assured { change_column :conversations, :receiver_id, :bigint }
  end

  def down
    safety_assured { change_column :conversations, :receiver_id, :integer }
  end
end
