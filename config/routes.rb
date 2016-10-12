require 'resque/server'

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
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

  get 'devices/:device_id/latest_spendings',
    controller: 'devices',
    action: 'latest_spendings',
    defaults: { format: :json }

  get 'devices/:device_id/notifications',
    controller: 'devices',
    action: 'notifications',
    defaults: { format: :json }

  get 'devices/:device_id/active_opportunities',
    controller: 'devices',
    action: 'active_opportunities',
    defaults: { format: :json }

  get 'devices/:device_id/configuration',
    controller: 'devices',
    action: 'configuration',
    defaults: { format: :json }

  put 'devices/:device_id/configuration',
    controller: 'devices',
    action: 'update_configuration',
    defaults: { format: :json }

  get 'operator/reads_total',
    controller: 'operators',
    action: 'reads_total',
    defaults: { format: :json }

  post 'users/devices',
    controller: 'users',
    action: 'assign_device',
    defaults: { format: :json }

  delete 'users/devices',
    controller: 'users',
    action: 'unassign_device',
    defaults: { format: :json }

  get 'users/devices',
    controller: 'users',
    action: 'index',
    defaults: { format: :json }

  mount Resque::Server.new, at: '/resque'
end
