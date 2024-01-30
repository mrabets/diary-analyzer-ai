# frozen_string_literal: true

class Stripe::BaseEventHandler
  extend Dry::Initializer

  param :event, reader: :private

  def self.call(event)
    new(event).call
  end

  def initialize(event)
    @event = event
  end

  def call
    raise NotImplementedError
  end
end
