# frozen_string_literal: true

class ConversationCreator
  def self.call(user:, params:)
    new(user:, params:).call
  end

  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    return find_conversation_by_id if params[:id].present?
    return find_conversation_by_receiver_id.presence || create_new_conversation if params[:receiver_id].present?

    nil
  end

  private

  attr_reader :user, :params

  def find_conversation_by_id
    Conversation.find_by(id: params[:id])
  end

  def find_conversation_by_receiver_id
    Conversation.where(sender_id: user.id, receiver_id: params[:receiver_id])
                .or(Conversation.where(sender_id: params[:receiver_id], receiver_id: user.id))
                .first
  end

  def create_new_conversation
    Conversation.create(sender_id: user.id, receiver_id: params[:receiver_id])
  end
end
