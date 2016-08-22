class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :set_json_format
  rescue_from ActionController::ParameterMissing,
    with: :parameter_missing_response

  private

  def parameter_missing_response(exception)
    render json: {
      error: "Missing Paramter: #{exception.message}"
    }, status: 400
  end

  def set_json_format
    params[:format] = :json
  end
end
