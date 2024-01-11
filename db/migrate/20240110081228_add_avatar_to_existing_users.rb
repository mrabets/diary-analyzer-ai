# frozen_string_literal: true

class AddAvatarToExistingUsers < ActiveRecord::Migration[7.1]
  class UserStub < ApplicationRecord
    self.table_name = :users

    serialize :data, coder: YAML, type: Hash
  end

  def up
    users_without_avatar.find_each do |user|
      user.data[:avatar_url] = Faker::Avatar.image
      user.save
    end
  end

  def down
    # no-op
  end

  private

  def users_without_avatar
    UserStub.where(data: nil).or(User.where("data NOT LIKE ?", "%avatar_url%"))
  end
end
