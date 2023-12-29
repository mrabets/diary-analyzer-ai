# frozen_string_literal: true

class ValidateChangePostsUserIdNullConstraint < ActiveRecord::Migration[7.1]
  def up
    validate_check_constraint :posts, name: "posts_user_id_null"
    change_column_null :posts, :user_id, false
    remove_check_constraint :posts, name: "posts_user_id_null"
  end

  def down
    add_check_constraint :posts, "user_id IS NOT NULL", name: "posts_user_id_null", validate: false
    change_column_null :posts, :user_id, true
  end
end
