# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authenticate_user!, except: [:webhook]
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def success
    redirect_to profile_path, notice: t(".success")
  end

  def cancel
    redirect_to profile_path, alert: t(".cancel")
  end

  def webhook
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      return head :bad_request
    end

    Stripe::WebhookService.call(event)

    head :ok
  end

  private

  def endpoint_secret
    ENV.fetch("STRIPE_ENDPOINT_SECRET") { nil }
  end
end
