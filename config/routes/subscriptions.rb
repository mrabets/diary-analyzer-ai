# frozen_string_literal: true

Rails.application.routes.draw do
  resources :subscriptions, only: %i[create] do
    collection do
      post :cancel
    end
  end
end
