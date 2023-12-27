# frozen_string_literal: true

class ConversationPresenter
  def initialize(conversation:, current_user:)
    @conversation = conversation
    @current_user = current_user
  end

  def companion
    conversation.sender == current_user ? conversation.receiver : conversation.sender
  end

  private

  attr_reader :conversation, :current_user
end
