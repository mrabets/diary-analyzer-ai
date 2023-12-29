# frozen_string_literal: true

class ChangePostsTitleNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :posts, "title IS NOT NULL", name: "posts_title_null", validate: false
  end
end
