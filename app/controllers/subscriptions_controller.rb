# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def create
    session = Stripe::CheckoutSessionCreator.call(current_user)

    redirect_to session.url, status: :see_other, allow_other_host: true
  end

  def cancel
    Stripe::SubscriptionCancelService.call(current_user)

    redirect_to profile_path, notice: t(".subscription_canceled")
  rescue Stripe::StripeError => e
    redirect_to profile_path, alert: e.message
  end
end
