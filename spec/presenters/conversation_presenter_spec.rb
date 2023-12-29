# frozen_string_literal: true

require "rails_helper"

describe ConversationPresenter do
  include_context "user"

  let(:receiver) { create(:user) }
  let(:conversation) { create(:conversation, sender: user, receiver:) }
  let(:presenter) { described_class.new(conversation:, current_user: user) }

  describe "#companion" do
    subject { presenter.companion }

    it { is_expected.to eq(receiver) }

    context "when current user is receiver" do
      let(:presenter) { described_class.new(conversation:, current_user: receiver) }

      it { is_expected.to eq(user) }
    end
  end
end
