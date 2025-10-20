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

  get '/notification_center', to: 'notification_center#index', as: :notification_center
  get '/notification_center/:id', to: 'notification_center#show', as: :notification_entry
  patch '/notification_center/:id/mark_as_read', to: 'notification_center#mark_as_read', as: :notification_mark_as_read
  patch '/notification_center/mark_all_as_read', to: 'notification_center#mark_all_as_read', as: :notification_mark_all_as_read
  
  resources :pets, only: [:new, :create, :show, :edit, :update] do
    resources :weight, only: [:new, :create], path: 'weight'
  end
  
  resources :expenses, only: [:index, :new, :create]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
  # root 'welcome#index'
  root 'home#index'
end
