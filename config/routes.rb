Rails.application.routes.draw do
  root to: 'houses#index'

  devise_for :users

  resources :customers
  resources :houses
end
