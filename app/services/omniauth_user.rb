# frozen_string_literal: true

class OmniauthUser
  include Dry::Monads[:result, :try]
  extend Dry::Initializer

  option :auth, reader: :private

  def self.find_or_create(auth)
    new(auth).find_or_create
  end

  def initialize(auth)
    @auth = auth
  end

  def find_or_create
    find_omniauth_user
      .or { find_registered_user }
      .or { create_omniauth_user }
  end

  private

  def find_omniauth_user
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ? Success(user) : Failure(:omniauth_user_not_found)
  end

  def find_registered_user
    user = User.find_by(email: auth.info.email)
    user ? Success(user) : Failure(:registered_user_not_found)
  end

  def create_omniauth_user
    Try[ActiveRecord::RecordInvalid] do
      User.create!(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        confirmed_at: Time.zone.now
      )
    end.to_result
  end
end
