# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts

  root "posts#index"

  get "/up", to: ->(_env) { [204, {}, [""]] }
end
