# frozen_string_literal: true

class AddProviderInfoToUsers < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :users, bulk: true do |t|
        t.string :provider
        t.string :uid
        t.string :name
      end
    end
  end
end
