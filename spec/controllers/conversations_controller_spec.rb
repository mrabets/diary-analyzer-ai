# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConversationsController do
  let(:receiver) { create(:user) }

  include_examples "with signed in user"

  describe "GET #show" do
    let(:conversation) { create(:conversation, sender: user, receiver:) }
    let!(:messages) { create_list(:message, 15, conversation:) }
    let(:page) { 1 }

    before { get :show, params: { id: conversation.id, page: } }

    it "returns http success and assigns variables" do
      expect(response).to have_http_status(:success)
      expect(assigns(:conversation)).to eq(conversation)
      expect(assigns(:messages)).to eq(messages.last(10))
      expect(assigns(:pagy)).to be_a(Pagy)
      expect(assigns(:presenter)).to be_a(ConversationPresenter)

      expect(response).to render_template(:show)
    end

    context "when page equals 2" do
      let(:page) { 2 }

      it "returns next messages" do
        expect(assigns(:messages)).to eq(messages.first(5))
      end
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
