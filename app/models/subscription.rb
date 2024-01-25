# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  id                      :bigint           not null, primary key
#  paid_until              :datetime
#  status                  :integer          default("canceled")
#  stripe_customer_ref     :string
#  stripe_subscription_ref :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Subscription < ApplicationRecord
  belongs_to :user

  enum :status, { canceled: 0, trialing: 1, active: 2, pending: 3 }

  def premium?
    status == "trialing" || status == "active"
  end
end
