Rails.application.routes.draw do
  namespace :file do
    resources :entries, only: :create
  end
  resources :shows, only: [] do
    resources :entries, only: :index, controller: 'shows/entries'
  end
end
