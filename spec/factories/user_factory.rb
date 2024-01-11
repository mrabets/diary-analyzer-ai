# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  data                   :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           not null
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_status_id         :bigint           default(1), not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_user_status_id        (user_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_status_id => user_statuses.id)
#
FactoryBot.define do
  factory :user, class: "User" do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { Faker::Internet.password }
    password_confirmation { password }
    uid { SecureRandom.uuid }

    after(:build) do |user|
      user.user_status_id ||= build(:user_status, uid: UserStatuses::OFFLINE).id
    end
  end
end
