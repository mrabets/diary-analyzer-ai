# frozen_string_literal: true

Rails.application.routes.draw do
  root "welcome#index"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: %i[index]

  get "profile", to: "users#show", as: "profile"
  get "profile/:id", to: "users#show", as: "user"

  resources :posts

  resources :conversations, only: %i[show create] do
    resources :messages, only: %i[create]
  end

  # Health check route
  get "/up", to: ->(_env) { [204, {}, [""]] }
end
