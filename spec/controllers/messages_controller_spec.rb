# frozen_string_literal: true

require "rails_helper"

describe MessagesController do
  include_examples "with signed in user"

  describe "POST create" do
    let(:receiver) { create(:user) }
    let(:conversation) { create(:conversation, sender: user, receiver:) }
    let(:params) { { conversation_id: conversation.id, message: { body: Faker::Lorem.sentence } } }
    let(:message) { build_stubbed(:message, conversation:, user:) }

    before { allow(MessageCreator).to receive(:call).and_return(message) }

    it "broadcasts message", :aggregate_failures do
      post :create, params:, format: :turbo_stream

      expect(MessageCreator).to have_received(:call)
      expect(response).to have_http_status(:success)
    end

    context "when message has not been saved" do
      let(:message) { nil }

      it "redirects back", :aggregate_failures do
        post :create, params:, format: :turbo_stream

        expect(MessageCreator).to have_received(:call)
        expect(response).to redirect_to(conversation_path(conversation))
      end
    end
  end
end
