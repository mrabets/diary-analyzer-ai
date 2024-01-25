# frozen_string_literal: true

class Stripe::CheckoutSessionCompletedHandler < Stripe::BaseEventHandler
  def call
    user_subscription.update!(status: stripe_subscription.status,
                              stripe_customer_ref: stripe_checkout_session.customer,
                              stripe_subscription_ref: stripe_checkout_session.subscription,
                              paid_until: Time.zone.at(stripe_subscription.current_period_end))
  end

  private

  def session
    event.data.object
  end

  def stripe_checkout_session
    @stripe_checkout_session ||= Stripe::Checkout::Session.retrieve(session.id)
  end

  def user_subscription
    Subscription.find(stripe_checkout_session.client_reference_id)
  end

  def stripe_subscription
    Stripe::Subscription.retrieve(stripe_checkout_session.subscription)
  end
end
