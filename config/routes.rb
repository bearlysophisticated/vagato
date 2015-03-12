Rails.application.routes.draw do

  # devise_for :users
  devise_for :users, controllers: { sessions: 'users/sessions'}

  root 'rooms#index'

  get 'pages/home'
  get 'pages/about'
  get 'pages/contact'
  get 'rooms/new/:acc_id' => 'rooms#new'
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
  resources :bookings

  get 'cart/index'
  patch 'cart/add'
  patch 'cart/remove'
  patch 'cart/clear'
  patch 'cart/book'
  post 'cart/book' => 'cart#finish_booking'
  patch 'cart/finish_booking'
  get '/cart' => 'cart#index'

  post 'filter/filter'
  get '/smartfilter' => 'filter#smartfilter'
  post '/do_smartfilter' => 'filter#do_smartfilter'

end
