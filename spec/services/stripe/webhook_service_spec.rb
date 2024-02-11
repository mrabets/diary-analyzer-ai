# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/VerifiedDoubles, :
describe Stripe::WebhookService do
  subject(:call) { described_class.call(event) }

  let(:event) { double(Stripe::Event, type: event_type, data: event_data) }
  let(:event_data) { double(Stripe::StripeObject, object: stripe_subscription) }
  let(:stripe_subscription) { double(Stripe::Subscription, id: stripe_subscription_ref, status: "canceled") }
  let(:stripe_subscription_ref) { "sub_123" }
  let!(:subscription) { create(:subscription, stripe_subscription_ref:, status: "active") }

  describe ".call" do
    before { allow(Stripe::SubscriptionDeletedHandler).to receive(:call).with(event) }

    context "when event type is customer.subscription.deleted" do
      let(:event_type) { "customer.subscription.deleted" }

      it "updates subscription status" do
        call

        expect(Stripe::SubscriptionDeletedHandler).to have_received(:call).with(event)
      end
    end

    context "when event type is checkout.session.completed" do
      let(:event_type) { "checkout.session.completed" }

      before { allow(Stripe::CheckoutSessionCompletedHandler).to receive(:call).with(event) }

      it "updates subscription status" do
        call

        expect(Stripe::CheckoutSessionCompletedHandler).to have_received(:call).with(event)
      end
    end

    context "when event type doesn't include in list" do
      let(:event_type) { "customer.subscription.created" }

      it "does not update subscription status", :aggregate_failures do
        call

        expect(subscription.reload.status).to eq("active")
      end
    end
  end
end
# rubocop:enable RSpec/VerifiedDoubles, RSpec/MultipleMemoizedHelpers:
