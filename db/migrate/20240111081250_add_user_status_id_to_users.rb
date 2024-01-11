# frozen_string_literal: true

class AddUserStatusIdToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_reference :users, :user_status, null: false, default: 1, index: { algorithm: :concurrently }
  end
end
