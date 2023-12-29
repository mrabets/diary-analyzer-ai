# frozen_string_literal: true

class ChangeMessagesUserIdToBigint < ActiveRecord::Migration[7.1]
  def up
    safety_assured { change_column :messages, :user_id, :bigint }
  end

  def down
    safety_assured { change_column :messages, :user_id, :integer }
  end
end
