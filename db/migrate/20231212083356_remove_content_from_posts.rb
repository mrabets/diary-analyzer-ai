# frozen_string_literal: true

class RemoveContentFromPosts < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :posts, :content, :text }
  end
end
