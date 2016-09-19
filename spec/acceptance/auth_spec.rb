require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Authentication' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  let(:sign_in_user) do
    create(
      :user,
      password: 'asdfasdf',
      password_confirmation: 'asdfasdf'
    ).tap(&:confirm)
  end

  post '/auth/sign_in' do
    example 'Get token' do
      do_request(email: sign_in_user.email, password: 'asdfasdf')

      expect(status).to eq 200
    end
  end
end
