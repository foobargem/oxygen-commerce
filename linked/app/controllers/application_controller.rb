class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user ||= Coupon.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user
  end

  def login_required
    unless logged_in?
      flash[:error] = "You must first log in or sign up before accessing this page."
      redirect_to login_url
    end
  end
  
end
