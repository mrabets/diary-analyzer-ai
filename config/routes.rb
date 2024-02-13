# frozen_string_literal: true

Rails.application.routes.draw do
  root "welcome#index"

  draw :users
  draw :subscriptions
  draw :payments

  resources :posts do
    member do
      post :analyze
    end
  end

  resources :conversations, only: %i[show create] do
    resources :messages, only: %i[create]
  end

  # Health check route
  get "/up", to: ->(_env) { [204, {}, [""]] }
end
