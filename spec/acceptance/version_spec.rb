require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Version' do
  get '/' do
    example 'Get version' do
      do_request

      expect(status).to eq(200)
    end
  end
end
