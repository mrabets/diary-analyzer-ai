# frozen_string_literal: true

class ValidateAddUsersIdPostsUserIdFk < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :posts, :users
  end
end
