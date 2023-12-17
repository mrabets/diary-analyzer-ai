# frozen_string_literal: true

Rails.application.routes.draw do
  root "welcome#index"
  get "welcome/index"
  get "profile", to: "users#profile"
  get "users", to: "users#index"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :posts

  resources :conversations do
    resources :messages
  end

  get "/up", to: ->(_env) { [204, {}, [""]] }
end
