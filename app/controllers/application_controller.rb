class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  skip_before_action :verify_authenticity_token, only: [:update, :destroy]
  before_action :authenticate
  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  attr_reader :current_user

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(auth_token: token)
    end
  end

  protected

  def render_response(status, json)
    render json: json, status: status
  end

  def not_authenticated
    response.headers['WWW-Authenticate'] = "Token realm=Application"
    render json: { error: 'not authorized' }, status: 401
  end

  def not_authorized
    render json: { errors: ['not authorized'] }, status: 403
  end

  def not_found
    render json: { error: 'not found' }, status: 404
  end

  def invalid_resource errors
    render json: { errors: errors }
  end
end
