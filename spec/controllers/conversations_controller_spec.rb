# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConversationsController do
  let(:receiver) { create(:user) }

  include_examples "with signed in user"

  describe "GET #show" do
    let(:conversation) { create(:conversation, sender: user, receiver:) }

    before { get :show, params: { id: conversation.id } }

    it "returns http success and assigns variables" do
      expect(response).to have_http_status(:success)
      expect(assigns(:conversation)).to eq(conversation)
      expect(assigns(:messages)).to eq(conversation.messages)
      expect(assigns(:presenter)).to be_a(ConversationPresenter)

      expect(response).to render_template(:show)
    end
  end

  describe "POST #create" do
    context "when conversation exists" do
      let!(:conversation) { create(:conversation, sender: user) }

      it "redirects to existed conversation" do
        expect { post :create, params: { receiver_id: conversation.receiver.id } }.not_to(change(Conversation, :count))

        expect(response).to redirect_to(conversation_path(conversation))
      end
    end

    context "when conversation does not exist" do
      it "creates a new conversation" do
        expect { post :create, params: { receiver_id: receiver.id } }.to change(Conversation, :count).by(1)

        expect(response).to redirect_to(conversation_path(Conversation.last))
      end
    end
  end
end
