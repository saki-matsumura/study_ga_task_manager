Rails.application.routes.draw do
  root "tasks#calendar"
  resources :tasks do
    collection do
      get 'calendar'
    end
  end
  resources :clients
  resources :type_of_tasks
  resources :image_authentications, only:[:create]
  resources :users, only: [:new, :create, :edit, :show, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :bookmarks, only: [:create, :destroy]
end
