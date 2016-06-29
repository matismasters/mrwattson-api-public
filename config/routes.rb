Rails.application.routes.draw do
  root 'versions#show'

  resource :version, only: [:show]
end
