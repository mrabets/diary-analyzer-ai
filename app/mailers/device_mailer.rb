# frozen_string_literal: true

class DeviceMailer < ApplicationMailer
  def registration_email(user)
    @user = user
    @social_links = {
      telegram: "https://t.me/mrabets",
      linkedin: "https://linkedin.com/in/karimmarabet",
      github: "https://github.com/mrabets"
    }

    mail(to: user.email, subject: I18n.t("device_mailer.welcome_subject"))
  end
end
