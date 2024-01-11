# frozen_string_literal: true

class CreateUserStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_statuses do |t|
      t.string :uid, null: false, index: { unique: true }
      t.boolean :is_online, default: false, null: false

      t.timestamps
    end
  end
end
