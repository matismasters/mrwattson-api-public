require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = :json
  config.curl_host = ENV['API_URL'] || 'http://localhost:3000'
  config.api_name = 'Mr.Wattson API'
  config.request_body_formatter = proc do |params|
    params.empty? ? nil : params.to_json
  end
end
