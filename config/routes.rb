Rails.application.routes.draw do
  get 'errors/internal_server_error'

  get 'welcome/index'
  root 'welcome#index'

  get "/login" => "users#login", as: "login"

  post "/sessions" => "sessions#login"

  delete "/sessions" => "sessions#logout", as: "logout" # logout_path is now defined

  post "/likes" => "likes#create"

  resources :artist

  resources :users

  match '/500', to: 'errors#internal_server_error', via: :all




end
