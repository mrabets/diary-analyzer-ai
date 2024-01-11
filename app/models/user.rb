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
class User < ApplicationRecord
  include StatusManager
  include Omniauth

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[google_oauth2 github]

  has_many :posts, dependent: :destroy, class_name: "Post"
  has_many :messages, dependent: :destroy, class_name: "Message"
  has_many :conversations, foreign_key: :sender_id, dependent: :destroy, inverse_of: :sender, class_name: "Conversation"
  has_one_attached :avatar

  serialize :data, coder: YAML, type: Hash

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }

  before_save :add_faker_avatar, :set_default_user_status, if: :new_record?

  private

  def set_default_user_status
    self.user_status_id = UserStatus.where(id: UserStatuses::OFFLINE).select(:id).first.id
  end

  def add_faker_avatar
    data[:avatar_url] = Faker::Avatar.image
  end
end
