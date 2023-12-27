# frozen_string_literal: true

require "rails_helper"

describe ConversationCreator do
  let(:user) { create(:user) }
  let(:receiver) { create(:user) }

  describe ".call" do
    subject(:call) { described_class.call(user:, params:) }

    context "when conversation exists" do
      let(:params) { { receiver_id: conversation.receiver.id } }
      let!(:conversation) { create(:conversation, sender: user) }

      it { is_expected.to eq(conversation) }
    end

    context "when conversation does not exist" do
      let(:params) { { receiver_id: receiver.id } }

      it "creates new conversation" do
        expect { call }.to change(Conversation, :count).by(1)
      end
    end

    context "when conversation id is present" do
      let!(:conversation) { create(:conversation, sender: user) }
      let(:params) { { id: conversation.id } }

      it { is_expected.to eq(conversation) }
    end

    context "when params are empty" do
      let(:params) { {} }

      it { is_expected.to be_nil }
    end
  end
end
