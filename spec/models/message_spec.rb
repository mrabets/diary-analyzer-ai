# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :integer
#  user_id         :integer
#
require "rails_helper"

describe Message do
  describe "associations" do
    it { is_expected.to belong_to(:conversation).class_name("Conversation") }
    it { is_expected.to belong_to(:user).class_name("User") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(10_000) }
    it { is_expected.to allow_value(Faker::Lorem.sentence).for(:body) }
    it { is_expected.not_to allow_value("").for(:body) }
  end
end
