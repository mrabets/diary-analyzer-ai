# frozen_string_literal: true

class MessageCreator
  def self.call(conversation:, user:, params:)
    new(conversation:, user:, params:).call
  end

  def initialize(conversation:, user:, params:)
    @conversation = conversation
    @user = user
    @params = params
  end

  def call
    message = Message.new(
      conversation_id: conversation.id,
      user_id: user.id,
      body: params.fetch(:body)
    )

    message.save ? message : nil
  end

  private

  attr_reader :conversation, :user, :params
end
