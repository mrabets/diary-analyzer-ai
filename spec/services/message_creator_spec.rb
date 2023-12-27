# frozen_string_literal: true

require "rails_helper"

describe MessageCreator do
  let(:user) { create(:user) }
  let(:receiver) { create(:user) }
  let(:conversation) { create(:conversation, sender: user, receiver:) }
  let(:params) { { body: } }
  let(:body) { Faker::Lorem.sentence }

  describe ".call" do
    subject(:call) { described_class.call(conversation:, user:, params:) }

    it "creates new message" do
      expect { call }.to change(Message, :count).by(1)
    end

    context "when body param is empty" do
      let(:body) { "" }

      it { is_expected.to be_nil }
    end
  end
end
