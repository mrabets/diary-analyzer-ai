# frozen_string_literal: true

class AddInitialUserStatuses < ActiveRecord::Migration[7.1]
  def up
    UserStatus.find_or_create_by(id: 1, uid: "offline", is_online: false)
    UserStatus.find_or_create_by(id: 2, uid: "online", is_online: true)
  end

  def down
    UserStatus.where(uid: %w[online offline]).destroy_all
  end
end
