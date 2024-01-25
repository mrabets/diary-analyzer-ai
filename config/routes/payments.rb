# frozen_string_literal: true

Rails.application.routes.draw do
  resources :payments, only: [] do
    collection do
      get :success
      get :cancel
      post :webhook
    end
  end
end
