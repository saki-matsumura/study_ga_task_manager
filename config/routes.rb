Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks
  resources :clients
  resources :type_of_tasks
  resources :image_authentications, only:[:create]
  resources :users, only: [:new, :create, :edit, :show, :update]
  resources :sessions, only: [:new, :create, :destroy]
end
