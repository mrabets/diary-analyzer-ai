# frozen_string_literal: true

class Stripe::SubscriptionDeletedHandler < Stripe::BaseEventHandler
  include Dry::Monads[:result, :try]

  def call
    user_subscription.bind(method(:update_subscription_status))
  end

  private

  def stripe_subscription
    @stripe_subscription ||= event.data.object
  end

  def user_subscription
    Try[ActiveRecord::RecordNotFound] { Subscription.find_by!(stripe_subscription_ref: stripe_subscription.id) }
  end

  def update_subscription_status(subscription)
    Try[ArgumentError] { subscription.update!(status: stripe_subscription.status) }
  end
end
