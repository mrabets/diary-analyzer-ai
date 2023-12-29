# frozen_string_literal: true

class ValidateChangePostsTitleNullConstraint < ActiveRecord::Migration[7.1]
  def up
    validate_check_constraint :posts, name: "posts_title_null"
    change_column_null :posts, :title, false
    remove_check_constraint :posts, name: "posts_title_null"
  end

  def down
    add_check_constraint :posts, "title IS NOT NULL", name: "posts_title_null", validate: false
    change_column_null :posts, :title, true
  end
end
