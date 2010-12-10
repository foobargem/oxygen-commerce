class ReservationsController < ApplicationController

  layout "subscriber"

  before_filter :login_required
  before_filter :find_coupon
  
  def index
    @reservations = @coupon.reservations
  end
  
  def new
    @reservation = Reservation.new
  end
  
  def edit
    @reservation = Reservation.find(params[:id])
  end
  
  def create
    @reservation = Reservation.new(params[:reservation])
    if @reservation.save
      redirect_to :reservations
    else
      render :action => :new
    end
  end
  
  def update
    @reservation = Reservation.find(params[:id])
    @reservation.height = params[:reservation][:height]
    @reservation.shoe_size = params[:reservation][:shoe_size]
    @reservation.resort = params[:reservation][:resort]
    @reservation.used_at = params[:reservation][:used_at]
    @reservation.part_time = params[:reservation][:part_time]    
    
    if @reservation.save
      flash[:notice] = "Reservation complete."
      redirect_to :action => 'index'
    else
      redirect_to :action => 'new'
    end
  end


  protected

    def find_coupon
      @coupon = Coupon.find(session[:user_id])
      @product = @coupon.product
    end
  
end
