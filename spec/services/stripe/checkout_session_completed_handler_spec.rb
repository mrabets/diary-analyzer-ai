# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/VerifiedDoubles
describe Stripe::CheckoutSessionCompletedHandler do
  let(:event) { double(Stripe::Event, type: event_type, data: event_data) }
  let(:stripe_subscription_ref) { "sub_123" }
  let(:event_type) { "checkout.session.completed" }
  let(:event_data) { double(Stripe::StripeObject, object: session) }
  let(:session) { double(id: subscription.id) }
  let!(:subscription) { create(:subscription) }
  let(:stripe_customer_ref) { "cus_123" }
  let(:stripe_checkout_session) do
    double(client_reference_id: subscription.id, subscription: stripe_subscription_ref,
           customer: stripe_customer_ref)
  end
  let(:subscription_status) { "active" }
  let(:current_period_end) { 1.month.from_now }
  let(:stripe_subscription) do
    double(Stripe::Subscription, status: subscription_status, current_period_end: current_period_end.to_i)
  end

  before do
    freeze_time
    allow(Stripe::Checkout::Session).to receive(:retrieve).with(session.id).and_return(stripe_checkout_session)
    allow(Stripe::Subscription).to receive(:retrieve).and_return(stripe_subscription)
    allow(Subscription).to receive(:find).and_return(subscription)
  end

  it "updates the subscription" do
    described_class.call(event)

    expect(subscription.reload.status).to eq("active")
    expect(subscription.reload.stripe_subscription_ref).to eq(stripe_subscription_ref)
    expect(subscription.reload.stripe_customer_ref).to eq(stripe_customer_ref)
    expect(subscription.reload.paid_until).to eq(current_period_end)
  end
end
# rubocop:enable RSpec/VerifiedDoubles, RSpec/MultipleMemoizedHelpers
