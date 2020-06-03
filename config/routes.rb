Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :users, only: [:index, :create]

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'welcome', to: 'sessions#welcome'

  get 'login', to: 'sessions#new', as: 'login'

  post 'login', to: 'sessions#create'

  get 'logout', to: 'sessions#logout'

  get 'authorized', to: 'sessions#page_requires_login'

  root 'sessions#welcome'
end
