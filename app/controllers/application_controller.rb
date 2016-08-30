class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_action :verify_authenticity_token
  include DeviseTokenAuth::Concerns::SetUserByToken

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
