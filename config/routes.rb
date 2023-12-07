# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :posts

  root "posts#index"

  get "/up", to: ->(_env) { [204, {}, [""]] }
end
