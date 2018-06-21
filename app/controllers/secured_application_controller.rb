class SecuredApplicationController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!, except: %i[auth]
end
