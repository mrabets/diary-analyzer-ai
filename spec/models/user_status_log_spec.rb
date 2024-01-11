# frozen_string_literal: true

require "rails_helper"

describe UserStatusLog do
  describe "validations" do
    it { is_expected.to validate_presence_of(:user_status_id) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user_status) }
    it { is_expected.to belong_to(:user) }
  end
end
