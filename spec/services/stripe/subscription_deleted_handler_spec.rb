# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/VerifiedDoubles
describe Stripe::SubscriptionDeletedHandler do
  let(:event) { double(Stripe::Event, type: event_type, data: event_data) }
  let(:event_type) { "customer.subscription.deleted" }
  let(:event_data) { double(Stripe::StripeObject, object: stripe_subscription) }
  let(:stripe_subscription) { double(Stripe::Subscription, id: stripe_subscription_id, status: "canceled") }
  let(:stripe_subscription_id) { stripe_subscription_ref }
  let(:stripe_subscription_ref) { "sub_123" }
  let!(:subscription) { create(:subscription, stripe_subscription_ref:, status: "active") }

  describe ".call" do
    it "updates subscription status" do
      described_class.call(event)

      expect(subscription.reload.status).to eq(stripe_subscription.status)
    end

    context "when subscription is not found" do
      let(:stripe_subscription_id) { "sub_456" }

      it "does nothing" do
        expect { described_class.call(event) }.not_to raise_error

        expect(subscription.reload.status).to eq("active")
      end
    end
  end
end
# rubocop:enable RSpec/VerifiedDoubles, RSpec/MultipleMemoizedHelpers
