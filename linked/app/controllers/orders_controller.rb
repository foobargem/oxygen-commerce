class OrdersController < ApplicationController

  layout "subscriber"

  before_filter :login_required, :except => :toggle_shoe_options
  before_filter :find_coupon, :except => :toggle_shoe_options
  before_filter :find_reservation, :except => :toggle_shoe_options
  
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

  def toggle_shoe_options
    wrapper_id = params[:wrapper_id]
    options = if params[:shoe_type] == "board"
                BOARD_STANCE_OPTIONS
              else
                SKI_OPTIONS
              end
    render :update do |page|
      page.replace_html "shoe_options_#{wrapper_id}", :partial => "orders/select_shoe_options", :locals => { :shoe_options => options }
    end
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
