# encoding: utf-8
class ReservationsController < ApplicationController
  def index
    @coupon = Coupon.find(session[:user_id])
  end
  
  def new
    @reservation = Reservation.new
    #@coupon = Coupon.find_by_coupon_number(session[:user_id])
  end
  
  def create
    @reservation = Reservation.new
    @reservation.coupon_id = Coupon.find(session[:user_id])
    @reservation.height = params[:reservation][:height]
    @reservation.shoe_size = params[:reservation][:shoe_size]
    @reservation.resort = params[:reservation][:resort]
    @reservation.used_at = params[:reservation][:used_at]
    @reservation.part_time = params[:reservation][:part_time]    
    
    if @reservation.save
      #session[:coupon_id] = nil
      flash[:notice] = "예약이 완료되었습니다."
      #redirect_to reservation_path
      redirect_to :action => 'index'
    else
      redirect_to :action => 'new'
      #session[:coupon_id] = nil
    end
  end
  
end
