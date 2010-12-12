class SessionsController < ApplicationController

  layout "blank"

  def new
  end

  def create
    if coupon = Coupon.authorize_by_coupon_and_purchaser(params)
      session[:user_id] = coupon.id
      flash[:notice] = "Successfuly logged in"
      redirect_to coupon_reservations_path
    else
      flash[:error] = "Authorize failed."
      render :action => :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Successfuly logged out."
    redirect_to root_path
  end
  
end
