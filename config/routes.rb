Rails.application.routes.draw do
  root 'versions#show'

  resource :version, only: [:show]
  resources :reading_events, only: [:create]
end
