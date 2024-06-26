# frozen_string_literal: true

class Stripe::WebhookService
  extend Dry::Initializer

  option :event, reader: :private

  def self.call(event)
    new(event).call
  end

  def initialize(event)
    @event = event
  end

  def call
    handler_class = EVENT_HANDLER_MAP[event.type]

    if handler_class
      handler_class.call(event)
    else
      Rails.logger.debug { "Unhandled event type: #{event.type}" }
    end
  end

  EVENT_HANDLER_MAP = {
    "customer.subscription.deleted" => Stripe::SubscriptionDeletedHandler,
    "checkout.session.completed" => Stripe::CheckoutSessionCompletedHandler
  }.freeze

  private_constant :EVENT_HANDLER_MAP
end
