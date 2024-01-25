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
FactoryBot.define do
  factory :subscription, class: "Subscription" do
    association :user, strategy: :build

    status { "canceled" }
    stripe_customer_ref { SecureRandom.uuid }
    stripe_subscription_ref { SecureRandom.uuid }
    paid_until { 1.month.from_now }
  end
end
