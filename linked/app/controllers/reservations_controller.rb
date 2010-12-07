# encoding: utf-8
class ReservationsController < ApplicationController
  before_filter :login_required
  
  def index
    @coupon = Coupon.find(session[:user_id])
  end
  
  def new
    if Reservation.find_by_coupon_id(session[:user_id])
      @reservation = Reservation.find_by_coupon_id(session[:user_id])
    else
      @reservation = Reservation.new
    end  
  end
  
  def edit
    @reservation = Reservation.find(params[:id])
  end
  
  def create

  end
  
  def update
    @reservation = Reservation.find(params[:id])
    @reservation.height = params[:reservation][:height]
    @reservation.shoe_size = params[:reservation][:shoe_size]
    @reservation.resort = params[:reservation][:resort]
    @reservation.used_at = params[:reservation][:used_at]
    @reservation.part_time = params[:reservation][:part_time]    
    
    if @reservation.save
      flash[:notice] = "예약이 완료되었습니다."
      redirect_to :action => 'index'
    else
      redirect_to :action => 'new'
    end
  end
  
end
