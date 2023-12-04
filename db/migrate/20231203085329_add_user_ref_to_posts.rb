# frozen_string_literal: true

class AddUserRefToPosts < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_reference :posts, :user, index: { algorithm: :concurrently }
  end
end
