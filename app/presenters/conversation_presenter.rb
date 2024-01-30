# frozen_string_literal: true

class ConversationPresenter
  include Dry.Types()
  extend Dry::Initializer

  option :conversation, type: Instance(Conversation), reader: :private
  option :current_user, type: Instance(User), reader: :private

  def initialize(conversation:, current_user:)
    @conversation = conversation
    @current_user = current_user
  end

  def companion
    conversation.sender == current_user ? conversation.receiver : conversation.sender
  end
end
