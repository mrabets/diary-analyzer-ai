# frozen_string_literal: true

require "rails_helper"

describe User::UpdateStatusJob do
  let(:user) { create(:user) }

  describe "#perform" do
    let(:online) { true }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_replace_to)

      described_class.perform_now(user, online)
    end

    it "updates user status" do
      expect(Turbo::StreamsChannel).to have_received(:broadcast_replace_to).with(
        "user_status",
        target: "user-status-#{user.id}",
        partial: "users/status",
        locals: { user:, online: }
      )
      expect(user.reload.user_status_id).to eq(UserStatuses::ONLINE)
      expect(UserStatusLog.last).to have_attributes(user_id: user.id, user_status_id: UserStatuses::ONLINE)
    end

    context "when user is not present" do
      let(:user) { nil }

      it "does not broadcast user status" do
        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_replace_to)
      end
    end
  end
end
