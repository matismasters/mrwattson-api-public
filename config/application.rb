require File.expand_path('../boot', __FILE__)

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'digest'

Bundler.require(*Rails.groups)

module Mwapi
  class Application < Rails::Application
    config.assets.enabled = false
    config.active_record.raise_in_transactional_callbacks = true
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          expose:  ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :delete, :put, :options]
      end
    end
  end
end
