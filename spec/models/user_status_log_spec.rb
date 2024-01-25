# frozen_string_literal: true

# == Schema Information
#
# Table name: user_status_logs
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer          not null
#  user_status_id :integer          not null
#
# Indexes
#
#  idx_user_status  (user_id,user_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (user_status_id => user_statuses.id)
#
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
