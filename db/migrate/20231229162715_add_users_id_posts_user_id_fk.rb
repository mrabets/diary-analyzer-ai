# frozen_string_literal: true

class AddUsersIdPostsUserIdFk < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :posts, :users, column: :user_id, primary_key: :id, validate: false
  end
end
