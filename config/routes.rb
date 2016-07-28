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

  get 'devices/:device_id/configuration',
    controller: 'devices',
    action: 'configuration',
    defaults: { format: :json }

  put 'devices/:device_id/configuration',
    controller: 'devices',
    action: 'update_configuration',
    defaults: { format: :json }

  mount Resque::Server.new, at: '/resque'

  match '*path', via: [:options], to:  lambda { |_|
    [204, {
      'Content-Type' => 'text/plain',
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => 'POST, GET, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers' => 'Origin, Content-Type, Accept, Authorization, Token',
      'Access-Control-Max-Age' => "1728000",
    }, []]
  }
end
