# frozen_string_literal: true

class Stripe::SubscriptionCancelService
  include Dry::Monads[:result, :try, :maybe]
  include Dry.Types
  extend Dry::Initializer

  option :user, type: Instance(User), reader: :private

  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    premium_subscription?
      .bind { cancel_stripe_subscription }
      .bind(method(:update_subscription_status))
  end

  private

  def cancel_stripe_subscription
    Try[Stripe::InvalidRequestError] { Stripe::Subscription.cancel(subscription.stripe_subscription_ref) }.to_result
  end

  def update_subscription_status(stripe_subscription)
    Try[ActiveRecord::RecordInvalid, ArgumentError] do
      subscription.update!(status: stripe_subscription.status)
    end.to_result
  end

  def subscription
    @subscription ||= user.subscription
  end

  def premium_subscription?
    Maybe(subscription).filter(&:premium?).to_result { "Subscription doesn't exist" }
  end
end
