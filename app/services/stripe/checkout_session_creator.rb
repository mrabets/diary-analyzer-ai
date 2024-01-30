# frozen_string_literal: true

class Stripe::CheckoutSessionCreator
  include Dry::Monads[:result, :try]
  include Dry.Types()
  extend Dry::Initializer

  option :user, type: Instance(User), reader: :private

  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    Try[Stripe::InvalidRequestError] { Stripe::Checkout::Session.create(session_params) }.to_result
  end

  private

  def session_params
    {
      client_reference_id:,
      customer_email:,
      success_url:,
      cancel_url:,
      line_items:,
      mode: "subscription",
      payment_method_collection: "if_required",
      subscription_data: (subscription_data unless subscription.canceled?)
    }.compact
  end

  def success_url
    "#{Rails.application.routes.url_helpers.success_payments_url}?session_id={CHECKOUT_SESSION_ID}"
  end

  def cancel_url
    Rails.application.routes.url_helpers.cancel_payments_url
  end

  def subscription
    Subscription.find_or_create_by!(user:) { |subscription| subscription.status = "pending" }
  end

  def client_reference_id
    subscription.id
  end

  def customer_email
    user.email
  end

  def line_items
    [{
      price: ENV.fetch("STRIPE_SUBSCRIPTION_PLAN_ID") { nil },
      quantity: 1
    }]
  end

  def subscription_data
    {
      trial_settings: { end_behavior: { missing_payment_method: "cancel" } },
      trial_period_days: 7
    }
  end
end
