# frozen_string_literal: true

class Stripe::SubscriptionCancelService
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    return unless subscription&.premium?

    stripe_subscription = Stripe::Subscription.cancel(subscription.stripe_subscription_ref)

    subscription.update!(status: stripe_subscription.status)
  end

  private

  attr_reader :user

  def subscription
    @subscription ||= user.subscription
  end
end
