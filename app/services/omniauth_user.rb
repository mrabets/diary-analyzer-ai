# frozen_string_literal: true

class OmniauthUser
  def self.find_or_create(auth)
    new(auth).find_or_create
  end

  def initialize(auth)
    @auth = auth
  end

  def find_or_create
    return omniauth_user if omniauth_user
    return registered_user if registered_user

    create_omniauth_user
  end

  private

  attr_reader :auth

  def omniauth_user
    @omniauth_user ||= User.find_by(provider: auth.provider, uid: auth.uid)
  end

  def registered_user
    @registered_user ||= User.find_by(email: auth.info.email)
  end

  def create_omniauth_user
    User.create(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      confirmed_at: Time.zone.now
    )
  end
end
