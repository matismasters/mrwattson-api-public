require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication' do
  include DefaultHeaders
  include AuthenticationHelpers

  post '/auth/sign_in' do
    example 'Get token' do
      do_request(email: current_user.email, password: 'asdfasdf')

      expect(status).to eq 200
    end
  end

  get '/operator/last_read_from_all_devices' do
    example 'Access restricted Area' do
      add_signed_in_user_authentication_headers

      do_request

      expect(status).to eq 200
    end
  end
end
