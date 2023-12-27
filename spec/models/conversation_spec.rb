# frozen_string_literal: true

# == Schema Information
#
# Table name: conversations
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :integer
#  sender_id   :integer
#
# Indexes
#
#  index_conversations_on_sender_id_and_receiver_id  (sender_id,receiver_id) UNIQUE
#
require "rails_helper"

RSpec.describe Conversation do
  describe "associations" do
    it { is_expected.to belong_to(:sender).class_name("User") }
    it { is_expected.to belong_to(:receiver).class_name("User") }
    it { is_expected.to have_many(:messages).dependent(:destroy).class_name("Message") }
  end

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:sender_id).scoped_to(:receiver_id) }
  end
end
