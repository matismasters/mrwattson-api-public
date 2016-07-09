require 'resque/server'

Rails.application.routes.draw do
  root 'versions#show'

  resource :version, only: [:show]

  post 'reading_events',
    controller: 'reading_events',
    action: 'create',
    defaults: { format: :json }

  get 'reading_events',
    controller: 'reading_events',
    action: 'index',
    defaults: { format: :json }

  get 'reading_events/latest',
    controller: 'reading_events',
    action: 'latest',
    defaults: { format: :json }

  mount Resque::Server.new, at: '/resque'
end
