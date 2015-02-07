Rails.application.routes.draw do
  resources :shouts

  resources :companies

  get 'kiosk/index'

  devise_for :users, class_name: 'FormUser', :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }
  root 'kiosk#index'
  get '/setup' => 'setup#index'
end