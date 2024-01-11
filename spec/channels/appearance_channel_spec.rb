# frozen_string_literal: true

require "rails_helper"

describe AppearanceChannel do
  include_context "user"

  let(:redis_key) { "user_status_online:#{user.id}" }

  before do
    stub_connection current_user: user
    allow(Rails.redis).to receive(:set)
    allow(User::UpdateStatusJob).to receive(:perform_later)
  end

  describe "#subscribed" do
    it "subscribes to the channel and updates user status to online" do
      subscribe

      expect(Rails.redis).to have_received(:set).with(redis_key, true)
      expect(User::UpdateStatusJob).to have_received(:perform_later).with(user, true)
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("appearance_channel")
    end
  end

  describe "#unsubscribed" do
    it "updates user status to offline" do
      subscribe
      unsubscribe

      expect(Rails.redis).to have_received(:set).with(redis_key, false)
      expect(User::UpdateStatusJob).to have_received(:perform_later).with(user, false)
    end
  end
end
