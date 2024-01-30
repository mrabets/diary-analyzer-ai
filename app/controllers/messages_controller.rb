# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!, :set_conversation

  def create
    message_result = create_message

    if message_result.success?
      broadcast_message(message_result.value!)
    else
      redirect_back fallback_location: conversation_path(@conversation), alert: message_result.failure
    end
  end

  private

  def create_message
    MessageCreator.call(conversation: @conversation, user: current_user, params: params[:message])
  end

  def broadcast_message(message)
    message.broadcast_append_to @conversation, partial: "messages/message", locals: { message: },
                                               target: "messages"
    respond_to(&:turbo_stream)
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end
