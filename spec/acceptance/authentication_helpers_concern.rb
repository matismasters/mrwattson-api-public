module AuthenticationHelpers
  extend ActiveSupport::Concern

  included do
    let(:current_user) { create(:user).tap(&:confirm) }
    let(:auth_headers) { current_user.create_new_auth_token }

    let(:add_signed_in_user_authentication_headers) do
      auth_headers.each do |key, value|
        header key, value
      end
    end
  end
end
