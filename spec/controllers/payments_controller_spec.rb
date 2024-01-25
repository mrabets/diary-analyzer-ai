# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/VerifiedDoubles
describe PaymentsController do
  include_context "with signed in user"

  describe "GET #success" do
    before { get :success }

    it "redirects to the root with a success notice" do
      expect(response).to redirect_to(profile_url)
      expect(flash[:notice]).to be_present
    end
  end

  describe "GET #cancel" do
    before { get :cancel }

    it "redirects to the root with a cancellation alert" do
      expect(response).to redirect_to(profile_url)
      expect(flash[:alert]).to be_present
    end
  end

  describe "POST #webhook" do
    let(:valid_signature_header) { "valid_signature" }
    let(:invalid_signature_header) { "invalid_signature" }
    let(:payload) { { data: "some_data" }.to_json }

    let(:event) { double(Stripe::Webhook) }

    before do
      allow(Stripe::WebhookService).to receive(:call).with(event)
      allow(ENV).to receive(:fetch).with("STRIPE_ENDPOINT_SECRET").and_return("endpoint_secret")
    end

    context "with valid Stripe signature" do
      before do
        allow(Stripe::Webhook).to receive(:construct_event).with(payload, valid_signature_header,
                                                                 "endpoint_secret").and_return(event)
        request.headers["HTTP_STRIPE_SIGNATURE"] = valid_signature_header

        post :webhook, body: payload
      end

      it "processes the webhook and returns ok" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid Stripe signature" do
      before do
        request.headers["HTTP_STRIPE_SIGNATURE"] = invalid_signature_header

        post :webhook, body: payload
      end

      it "returns a bad request status" do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
# rubocop:enable RSpec/VerifiedDoubles
