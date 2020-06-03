Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :users, only: [:index, :create]

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'welcome', to: 'sessions#welcome'

  root 'sessions#welcome'
end
