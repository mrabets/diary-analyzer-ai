# frozen_string_literal: true

class Stripe::BaseEventHandler
  def self.call(event)
    new(event).call
  end

  def initialize(event)
    @event = event
  end

  def call
    raise NotImplementedError
  end

  private

  attr_reader :event
end
