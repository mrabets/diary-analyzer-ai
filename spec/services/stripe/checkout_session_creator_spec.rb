# frozen_string_literal: true

require "rails_helper"

describe Stripe::CheckoutSessionCreator do
  subject(:call) { described_class.call(user) }

  include_context "user"

  let(:session_params) do
    {
      success_url:,
      cancel_url:,
      client_reference_id: subscription.id,
      customer_email: user.email,
      line_items: [
        {
          price:,
          quantity: 1
        }
      ],
      mode: "subscription",
      payment_method_collection: "if_required",
      subscription_data:
      {
        trial_period_days: 7,
        trial_settings: {
          end_behavior: {
            missing_payment_method: "cancel"
          }
        }
      }
    }
  end

  let(:price) { "price_1Oc1WbDdXO9Fb87C4sL52Gj9" }
  let(:success_url) { "http://localhost:3000/payments/success?session_id={CHECKOUT_SESSION_ID}" }
  let(:cancel_url) { "http://localhost:3000/payments/cancel" }

  let(:subscription) { build_stubbed(:subscription, status: "pending", user:) }

  before do
    allow(ENV).to receive(:fetch).with("STRIPE_SUBSCRIPTION_PLAN_ID").and_return(price)
    allow(Stripe::Checkout::Session).to receive(:create).with(session_params)
    allow(Subscription).to receive(:find_or_create_by!).with(user:).and_yield(subscription)
                                                       .and_return(subscription)
  end

  it "creates a checkout session" do
    call

    expect(Stripe::Checkout::Session).to have_received(:create).with(session_params)
  end
end
