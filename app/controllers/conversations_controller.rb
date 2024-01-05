# frozen_string_literal: true

class ConversationsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!, :set_conversation
  before_action :set_messages, :set_presenter, only: %i[show]

  def show
  end

  def create
    redirect_to conversation_path(@conversation)
  end

  private

  def set_conversation
    @conversation = ConversationCreator.call(user: current_user, params:)
  end

  def set_messages
    messages = @conversation.messages.order(created_at: :desc).includes(:user)
    @pagy, @messages = pagy(messages, items: 10)
    @messages = @messages.reverse
  end

  def set_presenter
    @presenter = ConversationPresenter.new(conversation: @conversation, current_user:)
  end
end
