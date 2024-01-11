# frozen_string_literal: true

class AddForeignKeyForUserStatusToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_foreign_key :users, :user_statuses, column: :user_status_id, validate: false
  end
end
