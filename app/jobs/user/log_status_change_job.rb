# frozen_string_literal: true

class User::LogStatusChangeJob < ApplicationJob
  def perform(user_id, user_status_id)
    UserStatusLog.create(user_id:, user_status_id:)
  end
end
