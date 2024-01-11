# frozen_string_literal: true

class AddDataToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :data, :text
  end
end
