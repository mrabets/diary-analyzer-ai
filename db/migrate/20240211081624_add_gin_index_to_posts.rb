# frozen_string_literal: true

class AddGinIndexToPosts < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :posts, :data, using: :gin, algorithm: :concurrently
  end
end
