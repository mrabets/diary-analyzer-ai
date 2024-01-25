# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/VerifiedDoubles
describe SubscriptionsController do
  include_context "with signed in user"

  describe "POST #create" do
    let(:stripe_checkout_session) { double("Stripe::CheckoutSession", url: "http://example.com/stripe_session") }

    before do
      allow(Stripe::CheckoutSessionCreator).to receive(:call).and_return(stripe_checkout_session)

      post :create
    end

    it "creates a Stripe Checkout session" do
      expect(Stripe::CheckoutSessionCreator).to have_received(:call).with(user)
    end

    it "redirects to the Stripe URL" do
      expect(response).to redirect_to(stripe_checkout_session.url)
      expect(response).to have_http_status(:see_other) # :see_other status code
    end
  end

  describe "POST #cancel" do
    let(:stripe_subscription) { double("Stripe::Subscription") }

    context "when Stripe cancels the subscription" do
      before do
        allow(Stripe::SubscriptionCancelService).to receive(:call)
        allow(Stripe::SubscriptionCancelService).to receive(:call).and_return(stripe_subscription)

        post :cancel
      end

      it "cancels the Stripe subscription" do
        expect(Stripe::SubscriptionCancelService).to have_received(:call).with(user)
      end

      it "redirects to the profile page with a notice" do
        expect(response).to redirect_to(profile_url)
        expect(flash[:notice]).to be_present
      end
    end

    context "when Stripe raises an error" do
      before do
        allow(Stripe::SubscriptionCancelService).to receive(:call)
          .and_raise(Stripe::StripeError.new("stripe error"))

        post :cancel
      end

      it "redirects to the profile page with an alert" do
        expect(response).to redirect_to(profile_url)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
# rubocop:enable RSpec/VerifiedDoubles
