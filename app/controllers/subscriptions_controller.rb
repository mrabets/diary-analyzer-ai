# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def create
    session = Stripe::CheckoutSessionCreator.call(current_user)

    if session.success?
      redirect_to session.value!.url, status: :see_other, allow_other_host: true
    else
      redirect_to profile_path, alert: session.failure
    end
  end

  def cancel
    result = Stripe::SubscriptionCancelService.call(current_user)

    if result.success?
      redirect_to profile_path, notice: t(".subscription_canceled")
    else
      redirect_to profile_path, alert: result.failure
    end
  end
end
