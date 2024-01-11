# frozen_string_literal: true

class CreateUsersStatusLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :user_status_logs do |t|
      t.integer :user_id, null: false
      t.integer :user_status_id, null: false

      t.timestamps
    end

    add_foreign_key :user_status_logs, :users, column: :user_id, validate: false
    add_foreign_key :user_status_logs, :user_statuses, column: :user_status_id, validate: false
    add_index :user_status_logs, %i[user_id user_status_id], name: "idx_user_status"
  end
end
