Rails.application.routes.draw do
  get 'reading_events/create'

  root 'versions#show'

  resource :version, only: [:show]
end
