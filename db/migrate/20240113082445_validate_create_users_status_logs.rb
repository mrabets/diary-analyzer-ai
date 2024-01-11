# frozen_string_literal: true

class ValidateCreateUsersStatusLogs < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :user_status_logs, :users
    validate_foreign_key :user_status_logs, :user_statuses
  end
end
