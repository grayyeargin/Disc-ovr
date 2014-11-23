Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  get "/login" => "users#login", as: "login"

  post "/sessions" => "sessions#login"

  delete "/sessions" => "sessions#logout", as: "logout" # logout_path is now defined

  resources :artist

  resources :users




end
