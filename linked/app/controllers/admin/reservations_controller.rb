class Admin::ReservationsController < ApplicationController

  def index
    @reservations = Reservation.paginate(:page => params[:page], :per_page => 20, :order => "id DESC")    
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @coupon = Coupon.new
    @reservation = Reservation.new
  end

  def create
    coupon = Coupon.new
    coupon.coupon_number = params[:coupon_number]
    coupon.purchaser_name = params[:purchaser_name]
    coupon.agency_name = params[:agency_name]
    coupon.phone_number = params[:phone_number]
    coupon.save
    
    reservation = Reservation.new
    reservation.coupon = coupon
    reservation.height = params[:reservation][:height]
    reservation.shoe_size = params[:reservation][:shoe_size]
    reservation.resort = params[:reservation][:resort]
    reservation.used_at = params[:reservation][:used_at]
    reservation.part_time = params[:reservation][:part_time]
    
    if reservation.save
      redirect_to admin_reservations_path
    else
      render :action => :new
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    reservation = Reservation.find(params[:id])
    coupon = reservation.coupon
    coupon.coupon_number = params[:coupon_number]
    coupon.purchaser_name = params[:purchaser_name]
    coupon.agency_name = params[:agency_name]
    coupon.phone_number = params[:phone_number]
    coupon.save
    
    reservation.coupon = coupon
    reservation.height = params[:reservation][:height]
    reservation.shoe_size = params[:reservation][:shoe_size]
    reservation.resort = params[:reservation][:resort]
    reservation.used_at = params[:reservation][:used_at]
    reservation.part_time = params[:reservation][:part_time]
    
    if reservation.save
      redirect_to admin_reservations_path
    else
      render :action => :new
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to admin_reservations_path
  end
  
end
