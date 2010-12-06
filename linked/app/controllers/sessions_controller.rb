# encoding: utf-8
class SessionsController < ApplicationController

  def new
  end

  def create
    coupon = Coupon.where("coupon_number = ? and purchaser_name = ?", params[:coupon_number], params[:purchaser_name]).first
    if coupon
      session[:user_id] = coupon.id
      flash[:notice] = "로그인이 성공적으로 되었습니다."
      redirect_to reservations_path
    else
      flash.now[:error] = "예약자 이름이나 쿠폰번호가 다릅니다."
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "로그아웃이 되었습니다."
    redirect_to "/"
  end
  
end
