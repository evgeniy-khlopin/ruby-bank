Rails.application.routes.draw do
  root 'home#index'

  resources :bank_accounts, only: :show
  resources :bank_transactions, only: :create

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy', as: :logout
end
