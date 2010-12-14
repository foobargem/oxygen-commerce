class ReservationsController < ApplicationController

  layout "subscriber"

  before_filter :login_required
  before_filter :find_coupon
  
  def index
    @reservations = @coupon.reservations
  end
  
  def edit
    @reservation = Reservation.find(params[:id])
    editable_checking
  end
  
  def update
    @reservation = Reservation.find(params[:id])
    editable_checking
    if @reservation.update_attributes(params[:reservation])
      redirect_to [:coupon, :reservations]
    else
      render :action => :edit
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    editable_checking
    @reservation.destroy
    redirect_to [:coupon, :reservations]
  end


  protected

    def find_coupon
      @coupon = Coupon.find(session[:user_id])
      @product = @coupon.product
    end
  
    def editable_checking
      unless @reservation.editable?
        redirect_to [:coupon, :reservations]
      end
    end

end
