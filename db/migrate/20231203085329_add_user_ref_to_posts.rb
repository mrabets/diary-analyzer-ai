# frozen_string_literal: true

class AddUserRefToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :user, foreign_key: true, index: true
  end
end
