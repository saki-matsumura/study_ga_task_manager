Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks
  resources :users, only: [:new, :create, :edit, :show, :update]
  resources :sessions, only: [:new, :create, :destroy]
end
