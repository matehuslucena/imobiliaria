Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: 'houses#index'

  resources :operations
  resources :houses do
    resources :reservations, only:[:create, :destroy]
    get 'my_houses', to: 'houses#customer_houses', on: :collection
  end

  get 'reservations', to: 'reservations#index'

  resources :user, :controller => "user"
end
