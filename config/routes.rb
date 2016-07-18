require 'resque/server'

Rails.application.routes.draw do
  root 'versions#show'

  resource :version, only: [:show]

  post 'reading_events',
    controller: 'reading_events',
    action: 'create',
    defaults: { format: :json }

  get 'devices/:device_id/reading_events/latest',
    controller: 'devices',
    action: 'latest',
    defaults: { format: :json }

  get 'devices/:device_id/notifications',
    controller: 'devices',
    action: 'notifications',
    defaults: { format: :json }

  mount Resque::Server.new, at: '/resque'
end
