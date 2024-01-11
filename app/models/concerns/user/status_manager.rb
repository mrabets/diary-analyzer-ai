# frozen_string_literal: true

module User::StatusManager
  extend ActiveSupport::Concern

  included do
    has_many :user_status_logs, class_name: "UserStatusLog", dependent: :destroy
    has_enumeration_for :user_status_id, with: UserStatuses

    after_create_commit :enqueue_log_status_change
  end

  def online?
    @online ||= begin
      user_status_boolean = Kredis.boolean("userstatus")
      user_status_boolean.value = Rails.redis.get("user_status_online:#{id}")
      user_status_boolean.value
    end
  end

  def enqueue_log_status_change
    User::LogStatusChangeJob.perform_later(id, user_status_id)
  end

  def last_seen_at
    user_status_logs.last&.created_at || created_at
  end
end
