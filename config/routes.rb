Rails.application.routes.draw do
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # 
  # Defines the root path route ("/")
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'  
  resources :password_resets, only: [:new, :create, :edit, :update]


  resources :users, only: [:new, :create, :show, :edit, :update]
  get       '/register',  to: 'users#new', as: 'users_new'

  
    resources :pets, only: [:new, :create, :show, :edit, :update] do
    resources :medications 
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root 'home#index'
end