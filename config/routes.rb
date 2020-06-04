Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :users, only: [:index, :create]

  get 'signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'

  get 'profile', to: 'users#profile', as: 'profile'
  post 'profile', to: 'users#update_profile'

  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'

  get 'logout', to: 'sessions#destroy'

  get 'forgot_password', to: 'sessions#forgot_password', as: 'forgot_password'
  post 'forgot_password', to: 'sessions#forgot_password'

  get 'welcome', to: 'sessions#welcome', as: 'welcome'
  root 'sessions#welcome'
end
