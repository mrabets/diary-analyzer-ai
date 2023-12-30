# frozen_string_literal: true

# == Schema Information
#
# Table name: conversations
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint           not null
#  sender_id   :bigint           not null
#
# Indexes
#
#  index_conversations_on_sender_id_and_receiver_id  (sender_id,receiver_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
class Conversation < ApplicationRecord
  db_belongs_to :sender, class_name: "User"
  db_belongs_to :receiver, class_name: "User"
  has_many :messages, class_name: "Message", dependent: :destroy

  validates :sender_id, db_uniqueness: { scope: :receiver_id }
end
