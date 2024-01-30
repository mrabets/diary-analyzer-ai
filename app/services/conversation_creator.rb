# frozen_string_literal: true

class ConversationCreator
  include Dry::Monads[:result, :maybe, :try]
  include Dry.Types()
  extend Dry::Initializer

  option :user, type: Instance(User), reader: :private
  option :params, type: Types::Hash, reader: :private

  def self.call(user:, params:)
    new(user:, params:).call
  end

  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    find_conversation_by_id
      .or { find_or_create_conversation_by_receiver_id }
      .value_or(nil)
  end

  private

  def find_conversation_by_id
    return Failure(:no_id_provided) unless params[:id]

    Maybe(Conversation.find_by(id: params[:id]))
      .to_result(:conversation_not_found)
  end

  def find_or_create_conversation_by_receiver_id
    return Failure(:no_receiver_id_provided) unless params[:receiver_id]

    conversation = find_conversation_by_receiver_id

    conversation ? Success(conversation) : create_new_conversation
  end

  def find_conversation_by_receiver_id
    Conversation.where(sender_id: user.id, receiver_id: params[:receiver_id])
                .or(Conversation.where(sender_id: params[:receiver_id], receiver_id: user.id))
                .first
  end

  def create_new_conversation
    Try(ActiveRecord::RecordInvalid) do
      Conversation.create(sender_id: user.id, receiver_id: params[:receiver_id])
    end.to_result
  end
end
