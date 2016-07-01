require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = [:html]
  config.curl_host = 'http://localhost:3000'
  config.api_name = 'Generic API'
  config.request_body_formatter = Proc.new do |params|
    params.empty? ? nil : params.to_json
  end
end
