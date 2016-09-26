require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do
  include DefaultHeaders

  let(:user_params) do
    {
      email: 'user@example.com',
      password: 'password',
      password_confirmaiton: 'password'
    }
  end

  post '/auth' do
    parameter :email, 'String::User email'
    parameter :password, 'String::Account password'
    parameter :password_confirmation, 'String:: Account password confirmation'

    response_field :data, 'Hash::All user data'
    response_field :'*email', 'String::Account email'

    example 'Sign up with email' do
      do_request(user_params)

      expect(User.count).to eq 1

      json_response = JSON.parse(response_body)['data']

      expect(json_response['email']).to eq 'user@example.com'
    end
  end
end
