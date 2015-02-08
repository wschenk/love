Rails.application.routes.draw do
  resources :slack_users

  resources :shouts

  resources :companies

  get 'kiosk/index'

  post '/slack_message' => 'slack#message'

  devise_for :users, class_name: 'FormUser', :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }
  root 'kiosk#index'
  get '/setup' => 'setup#index'
end