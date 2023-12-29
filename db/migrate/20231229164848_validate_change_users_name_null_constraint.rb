# frozen_string_literal: true

class ValidateChangeUsersNameNullConstraint < ActiveRecord::Migration[7.1]
  def up
    validate_check_constraint :users, name: "users_name_null"
    change_column_null :users, :name, false
    remove_check_constraint :users, name: "users_name_null"
  end

  def down
    add_check_constraint :users, "name IS NOT NULL", name: "users_name_null", validate: false
    change_column_null :users, :name, true
  end
end
