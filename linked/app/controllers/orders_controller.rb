class OrdersController < ApplicationController

  layout "subscriber"

  before_filter :login_required
  before_filter :find_coupon
  before_filter :find_reservation
  
  def index
    @orders = @reservation.orders
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order])
      redirect_to [@reservation, :orders]
    else
      render "edit"
    end
  end

  def destroy
  end


  protected

    def find_coupon
      @coupon = Coupon.find(session[:user_id])
      @product = @coupon.product
    end

    def find_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

end
