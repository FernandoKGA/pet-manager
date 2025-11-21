Rails.application.routes.draw do
  
  get 'home/index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :users, only: [:new, :create, :show, :edit, :update]
  get '/register', to: 'users#new', as: 'users_new'

  get '/notification_center', to: 'notification_center#index', as: :notification_center
  get '/notification_center/:id', to: 'notification_center#show', as: :notification_entry
  patch '/notification_center/:id/mark_as_read', to: 'notification_center#mark_as_read', as: :notification_mark_as_read
  patch '/notification_center/mark_all_as_read', to: 'notification_center#mark_all_as_read', as: :notification_mark_all_as_read

  resources :baths, only: [:show, :edit, :update, :destroy]

  namespace :notification_center do
    resources :custom_reminders, only: [:new, :create]
  end

  # 🔥 Rotas de memorial adicionadas do Código 2
  get '/memorial', to: 'memorial#index', as: :memorial
  get '/memorial/:id', to: 'memorial#show', as: :memorial_pet

  resources :pets, only: [:new, :create, :show, :edit, :update, :destroy] do
    # 🔥 Rota nova para adicionar pet ao memorial
    post :add_to_memorial, on: :member

    resources :medical_appointments
    resources :weights, only: [:index, :new, :create]
    resources :baths
    resources :weights, only: [:index, :new, :create]
    resources :diary_entries, only: [:index, :create, :destroy]
    resources :medications, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :vaccinations, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :expenses, only: [:index, :new, :create]

  get "up" => "rails/health#show", as: :rails_health_check
  root 'home#index'
end
