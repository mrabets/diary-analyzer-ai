# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: %i[index]
  get "profile", to: "users#show", as: "profile"
  get "profile/:id", to: "users#show", as: "user"
end
