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
class UserStatusLog < ApplicationRecord
  db_belongs_to :user_status, class_name: "UserStatus"
  db_belongs_to :user, class_name: "User"

  validates :user_status_id, presence: true
  validates :user_id, presence: true
end
