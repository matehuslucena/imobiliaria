Rails.application.routes.draw do
  devise_for :user
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root to: 'houses#index'

  resources :operations
  resources :customers
  resources :houses
end
