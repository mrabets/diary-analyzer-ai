# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController do
  shared_examples "Omniauth callbacks" do |provider|
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]

      OmniAuth.config.mock_auth[provider] = auth_hash
      allow(User).to receive(:from_omniauth).and_return(user)
    end

    context "when omniauth is successful" do
      let(:user) { build_stubbed(:user, confirmed_at: Time.current) }
      let(:auth_hash) do
        OmniAuth::AuthHash.new({
                                 provider:,
                                 uid: SecureRandom.uuid,
                                 info: {
                                   email: Faker::Internet.email,
                                   name: Faker::Name.name
                                 },
                                 credentials: { token: SecureRandom.hex,
                                                expires_at: 1.week.from_now }
                               })
      end

      it "redirects to the root path with success message" do
        get provider

        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to match(/Successfully authenticated from/)
        expect(controller.current_user).to eq(user)
      end
    end

    context "when omniauth fails" do
      let(:user) { nil }
      let(:auth_hash) do
        OmniAuth::AuthHash.new({
                                 provider:,
                                 uid: nil,
                                 info: {
                                   email: nil,
                                   name: nil
                                 }
                               })
      end

      it "redirects to the sign in path with alert message" do
        get provider

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to match(/is not authorized/)
      end
    end
  end

  describe "GET #google_oauth2" do
    it_behaves_like "Omniauth callbacks", :google_oauth2
  end

  describe "GET #github" do
    it_behaves_like "Omniauth callbacks", :github
  end
end
