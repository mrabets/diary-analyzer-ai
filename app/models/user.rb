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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # Temporarily disable confirmable to avoid sending confirmation email
         # :confirmable,
         :omniauthable, omniauth_providers: %i[google_oauth2 github]

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }

  has_many :posts, dependent: :destroy, class_name: "Post"
  has_many :messages, dependent: :destroy, class_name: "Message"
  has_many :conversations, foreign_key: :sender_id, dependent: :destroy, inverse_of: :sender, class_name: "Conversation"

  has_one_attached :avatar
  serialize :data, coder: YAML, type: Hash

  before_save :add_faker_avatar

  def self.from_omniauth(auth)
    OmniauthUser.find_or_create(auth)
  end

  def self.all_except(user)
    where.not(id: user)
  end

  private

  def add_faker_avatar
    # ActiveStorage doesn't support adding attachments from local files yet
    # avatar.attach(io: URI.parse(Faker::Avatar.image).open, filename: "default_avatar.png", content_type: "image/png")
    # So I use this link to add faker avatar
    data[:avatar_url] = Faker::Avatar.image
  end
end
