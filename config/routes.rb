Rails.application.routes.draw do
  
  get 'home/index'

  get 'sobre', to: 'home#about', as: 'about'
  get 'contato', to: 'home#contact', as: 'contact'
  get 'funcionalidades', to: 'home#features', as: 'features'

  # Sessions
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Password reset
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Users + rota para remover foto
  resources :users, only: [:new, :create, :show, :edit, :update] do
    member do
      delete :remove_photo
    end
  end

  get '/register', to: 'users#new', as: 'users_new'

  # Notification center
  get  '/notification_center',               to: 'notification_center#index',        as: :notification_center
  get  '/notification_center/:id',           to: 'notification_center#show',         as: :notification_entry
  patch '/notification_center/:id/mark_as_read', to: 'notification_center#mark_as_read', as: :notification_mark_as_read
  patch '/notification_center/mark_all_as_read', to: 'notification_center#mark_all_as_read', as: :notification_mark_all_as_read

  resources :baths, only: [:show, :edit, :update, :destroy]

  namespace :notification_center do
    resources :custom_reminders, only: [:new, :create]
  end
 
  get '/memorial', to: 'memorial#index', as: :memorial
  
  # Pets
  resources :pets, only: [:new, :create, :show, :edit, :update, :destroy] do
    member do
      patch :deactivate
      patch :activate
    end
    collection do
      get :inactive
    end
    resources :medical_appointments
    resources :weights, only: [:index, :new, :create]
    resources :baths
    resources :weights, only: [:index, :new, :create]  # repetido, mas mantive igual ao seu
    resources :diary_entries, only: [:index, :create, :destroy]
    resources :medications,   only: [:index, :new, :create, :edit, :update, :destroy]
    resources :vaccinations,  only: [:index, :new, :create, :edit, :update, :destroy]
  end
  
  resources :expenses, only: [:index, :new, :create, :edit, :update, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check
  root 'home#index'
end
