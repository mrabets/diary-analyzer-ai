# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "mrabets@proton.me"
  layout "mailer"
end
