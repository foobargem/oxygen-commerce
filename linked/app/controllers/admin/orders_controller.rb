class Admin::OrdersController < ApplicationController

  before_filter :authenticate_admin!
  before_filter :find_reservation_with_others

  layout "admin"


  def index
    @orders = @reservation.orders
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order])
      redirect_to [:admin, @product, @reservation, :orders]
    else
      render :action => :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    if @reservation.orders.size == 0
      redirect_to [:admin, @product, :reservations]
    else
      redirect_to [:admin, @product, @reservation, :orders]
    end
  end

  protected

    def find_reservation_with_others
      @reservation = Reservation.find(params[:reservation_id])
      @coupon = @reservation.coupon
      @product = @reservation.product
    end

end
