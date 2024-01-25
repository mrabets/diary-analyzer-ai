# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/VerifiedDoubles
describe Stripe::SubscriptionCancelService do
  let(:user) { create(:user) }
  let(:subscription_status) { "active" }
  let(:subscription) { create(:subscription, user:, status: subscription_status) }
  let(:stripe_subscription) { double(Stripe::Subscription, status: "canceled") }

  before do
    allow(Stripe::Subscription).to receive(:cancel).with(subscription.stripe_subscription_ref)
                                                   .and_return(stripe_subscription)
  end

  describe "#call" do
    subject(:call) { described_class.call(user) }

    it "cancels subscription" do
      call

      expect(subscription.reload.status).to eq("canceled")
      expect(Stripe::Subscription).to have_received(:cancel)
    end

    context "when subscription is not premium" do
      let(:subscription_status) { "canceled" }

      it "does nothing" do
        call

        expect(Stripe::Subscription).not_to have_received(:cancel)
      end
    end
  end
end
# rubocop:enable RSpec/VerifiedDoubles
