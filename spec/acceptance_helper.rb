require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = :json
  config.request_headers_to_include = %w(Accept Content-Type)
  config.response_headers_to_include = %w(Content-Type)
  config.curl_host = 'https://mrwattson-api.herokuapp.com'
  config.curl_headers_to_filter = %w(Cookie Host)
  config.api_name = 'Mr.Wattson API'
  config.request_body_formatter = proc do |params|
    params.empty? ? nil : params.to_json
  end
end
