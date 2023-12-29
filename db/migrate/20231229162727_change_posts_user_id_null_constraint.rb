# frozen_string_literal: true

class ChangePostsUserIdNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :posts, "user_id IS NOT NULL", name: "posts_user_id_null", validate: false
  end
end
