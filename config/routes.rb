Rails.application.routes.draw do

  resources :bookings

  # devise_for :users
  devise_for :users, controllers: { sessions: 'users/sessions'}

  root 'rooms#index'

  get 'pages/home'
  get 'pages/about'
  get 'pages/contact'
  get 'rooms/new_owner/:acc_id' => 'rooms#new_owner'
  get 'accommodations/index_owner' => 'accommodations#index_owner'
  get 'accommodations/index_admin' => 'accommodations#index_admin'

  resources :prices
  resources :addresses
  resources :rooms
  resources :accommodations
  resources :equipment
  resources :categries
  resources :serviices
  resources :guests
  resources :owners
  resources :admins
  resources :users
  resources :settings

end
