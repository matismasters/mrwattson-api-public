require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Versions' do
  include DefaultHeaders

  let(:expected_headers) do
    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end

  let(:expected_content) { { 'version' => '1.2' }.to_json }

  get '/' do
    example 'Get API version from root url' do
      do_request

      expect(status).to eq 200
      expect(headers).to eq expected_headers
      expect(response_body).to eq expected_content
    end
  end

  get '/version' do
    example 'Get API version from version url' do
      do_request

      expect(status).to eq 200
      expect(headers).to eq expected_headers
      expect(response_body).to eq expected_content
    end
  end
end
