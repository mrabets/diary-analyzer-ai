# frozen_string_literal: true

class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance_channel"

    update_user_status(true)
  end

  def unsubscribed
    update_user_status(false)
  end

  private

  def update_user_status(online)
    Rails.redis.set(user_status_key, online)

    User::UpdateStatusJob.perform_later(current_user, online)
  end

  def user_status_key
    @user_status_key ||= "user_status_online:#{current_user.id}"
  end
end
