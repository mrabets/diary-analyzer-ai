# frozen_string_literal: true

require "rails_helper"

describe User::LogStatusChangeJob do
  let(:user) { create(:user) }

  describe "#perform" do
    let(:user_status_id) { UserStatuses::ONLINE }

    before { described_class.perform_now(user.id, user_status_id) }

    it "creates a user status log" do
      expect(UserStatusLog.last).to have_attributes(user_id: user.id, user_status_id:)
    end
  end
end
