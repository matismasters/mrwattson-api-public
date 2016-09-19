module AuthenticationHelpers
  extend ActiveSupport::Concern

  included do
    before do
      @confirmed_user = create(:user).tap(&:confirm)

      @auth_headers = @confirmed_user.create_new_auth_token
    end

    let(:add_signed_in_user_authentication_headers) do
      @auth_headers.each do |key, value|
        header key, value
      end
    end
  end
end
