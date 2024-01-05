# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!, :set_conversation

  def create
    if message
      message.broadcast_append_to @conversation, partial: "messages/message", locals: { message: },
                                                 target: "messages"

      respond_to(&:turbo_stream)
    else
      redirect_back fallback_location: conversation_path(@conversation)
    end
  end

  private

  def message
    @message ||= MessageCreator.call(conversation: @conversation, user: current_user, params: params[:message])
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end
