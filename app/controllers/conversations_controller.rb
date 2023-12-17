# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.all
  end

  def create
    @conversation = Conversation.new(conversation_params)
    if @conversation.save
      redirect_to conversations_path
    else
      render :new
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:sender_id, :receiver_id)
  end
end
