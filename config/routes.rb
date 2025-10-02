Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Rotas para pets
  resources :pets, only: [:new, :create, :show, :edit, :update]
  
  # Rotas para users
  resources :users, only: [:create, :show]
  get '/register', to: 'users#new', as: 'users_new'
  
  resources :pets, only: [:new, :create, :show]
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Defines the root path route ("/")
  # root "posts#index"
  # root 'welcome#index'
  root 'home#index'
end