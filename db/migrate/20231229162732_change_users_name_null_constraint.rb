# frozen_string_literal: true

class ChangeUsersNameNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :users, "name IS NOT NULL", name: "users_name_null", validate: false
  end
end
