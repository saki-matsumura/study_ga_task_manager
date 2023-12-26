Rails.application.routes.draw do
  root "tasks#calendar"
  resources :tasks do
    collection do
      get 'calendar'
      get 'bookmark'
    end
  end
  resources :clients, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :type_of_tasks, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :image_authentications, only:[:create]
  resources :users, only: [:new, :create, :edit, :show, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :bookmarks, only: [:create, :destroy]
end
