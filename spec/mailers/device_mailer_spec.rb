# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeviceMailer do
  describe "registration_email" do
    let(:user) { create(:user) }
    let(:mail) { described_class.registration_email(user) }

    it "renders the headers", :aggregate_failures do
      expect(mail.subject).to eq(I18n.t("device_mailer.welcome_subject"))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["mrabets@proton.me"])
    end

    it "renders the body", :aggregate_failures do
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match("https://t.me/mrabets")
      expect(mail.body.encoded).to match("https://linkedin.com/in/karimmarabet")
      expect(mail.body.encoded).to match("https://github.com/mrabets")
    end
  end
end
