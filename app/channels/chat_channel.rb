# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    conversation = Conversation.find(params[:conversation_id])
    stream_for conversation
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create!(conversation_id: data["conversation_id"], user_id: current_user.id, body: data["message"])
  end
end
