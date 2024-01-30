# frozen_string_literal: true

class MessageCreator
  include Dry::Monads[:result, :try]
  include Dry.Types
  extend Dry::Initializer

  option :conversation, type: Instance(Conversation), reader: :private
  option :user, type: Instance(User), reader: :private
  option :params, type: Types::Hash, reader: :private

  def self.call(conversation:, user:, params:)
    new(conversation:, user:, params:).call
  end

  def initialize(conversation:, user:, params:)
    @conversation = conversation
    @user = user
    @params = params
  end

  def call
    create_message
  end

  private

  def create_message
    Try[ActiveRecord::RecordInvalid] do
      Message.create!(
        conversation_id: conversation.id,
        user_id: user.id,
        body: params.fetch(:body)
      )
    end.to_result
  end
end
