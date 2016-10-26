Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: 'houses#index'

  resources :operations
  resources :houses
  resources :user, :controller => "user"
end
