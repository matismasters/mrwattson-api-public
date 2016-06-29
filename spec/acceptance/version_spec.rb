require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Versions' do
  header 'Accept', 'application/json'

  get '/' do
    example 'Get version' do
      do_request

      expect(status).to eq 200
      expect(headers).to eq({ "Accept" => 'application/json' })
      expect(response_body).to eq({ "version" => "1.1" }.to_json)
    end
  end

  get '/version' do
    example 'Get version' do
      do_request

      expect(status).to eq 200
      expect(headers).to eq({ "Accept" => 'application/json' })
      expect(response_body).to eq({ "version" => "1.1" }.to_json)
    end
  end
end
