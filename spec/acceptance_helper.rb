require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = :json

  protocol = ENV['RAILS_ENV'] == 'production' ? 'https' : 'http'
  config.curl_host = "#{protocol}://#{ENV['HOST_URL'] || 'localhost:3000'}"

  config.curl_headers_to_filter = %w(Cookie Host)
  config.api_name = 'Mr.Wattson API'
  config.request_body_formatter = proc do |params|
    params.empty? ? nil : params.to_json
  end
end
