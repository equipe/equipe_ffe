Rails.application.routes.draw do
  namespace :file do
    resources :entries, only: :create
    resources :results, only: :create
  end
  resources :results, only: :create
  resources :shows, only: [] do
    resources :entries, only: :index, controller: 'shows/entries'
  end
end
