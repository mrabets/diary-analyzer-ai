# frozen_string_literal: true

# == Schema Information
#
# Table name: user_statuses
#
#  id         :bigint           not null, primary key
#  is_online  :boolean          default(FALSE), not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_statuses_on_uid  (uid) UNIQUE
#
FactoryBot.define do
  factory :user_status, class: "UserStatus" do
    uid { "offline" }
  end
end
