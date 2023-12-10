# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth(SocialNetwork::GOOGLE)
  end

  def github
    handle_auth(SocialNetwork::GITHUB)
  end

  private

  def handle_auth(provider)
    if user.present?
      successful_authentication(user, provider)
    else
      failed_authentication(provider)
    end
  end

  def user
    @user ||= User.from_omniauth(auth)
  end

  def successful_authentication(user, provider)
    sign_out_all_scopes
    flash[:success] = t "devise.omniauth_callbacks.success", kind: provider.capitalize
    sign_in_and_redirect user, event: :authentication
  end

  def failed_authentication(provider)
    flash[:alert] =
      t "devise.omniauth_callbacks.failure", kind: provider, reason: "#{auth.info.email} is not authorized."
    redirect_to new_user_session_path
  end

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end
