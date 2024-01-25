# frozen_string_literal: true

class Stripe::SubscriptionDeletedHandler < Stripe::BaseEventHandler
  def call
    user_subscription&.update!(status: stripe_subscription.status)
  end

  private

  def stripe_subscription
    @stripe_subscription ||= event.data.object
  end

  def user_subscription
    Subscription.find_by(stripe_subscription_ref: stripe_subscription.id)
  end
end
