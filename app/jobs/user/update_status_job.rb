# frozen_string_literal: true

class User::UpdateStatusJob < ApplicationJob
  def perform(user, online)
    return unless user

    user.update(user_status_id: online ? UserStatuses::ONLINE : UserStatuses::OFFLINE)

    Turbo::StreamsChannel.broadcast_replace_to("user_status",
                                               target: "user-status-#{user.id}",
                                               partial: "users/status",
                                               locals: { user:, online: })

    UserStatusLog.create(user_id: user.id, user_status_id: user.user_status_id)
  end
end
