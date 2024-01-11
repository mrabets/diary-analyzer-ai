# frozen_string_literal: true

require "rails_helper"

describe Users::RegistrationsController do
  describe "POST #create" do
    before { request.env["devise.mapping"] = Devise.mappings[:user] }

    context "when user is valid" do
      let(:user_params) { { user: attributes_for(:user) } }

      it "triggers DeviceMailer" do
        post :create, params: user_params

        expect(ActionMailer::MailDeliveryJob).to have_been_enqueued.on_queue("default")
      end

      it "creates a new user" do
        expect do
          post :create, params: user_params
        end.to change(User, :count).by(1)
      end
    end

    context "when user is invalid" do
      let(:invalid_user_params) { { user: attributes_for(:user, email: nil) } }

      it "does not trigger DeviceMailer" do
        expect do
          post :create, params: invalid_user_params
        end.not_to change(ActionMailer::Base.deliveries, :count)
      end

      it "does not create a new user" do
        expect do
          post :create, params: invalid_user_params
        end.not_to change(User, :count)
      end
    end
  end
end
