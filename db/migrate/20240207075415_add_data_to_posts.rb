# frozen_string_literal: true

class AddDataToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :data, :text
  end
end
