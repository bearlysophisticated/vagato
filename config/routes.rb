Rails.application.routes.draw do

  devise_for :users

  root 'accommodations#index'

  get 'pages/home'
  get 'pages/about'
  get 'pages/contact'
  get 'rooms/new_owner/:acc_id' => 'rooms#new_owner'
  get 'szallasaim' => 'accommodations#szallasaim'

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

end
