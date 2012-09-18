class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :redirect_https

  def redirect_https
    redirect_to :protocol => "https://" unless request.ssl? or Rails.env.development?
    return true
  end

  def handle_unverified_request
    raise(ActionController::InvalidAuthenticityToken)
  end

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
end
