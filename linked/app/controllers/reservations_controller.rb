class ReservationsController < ApplicationController

  layout "subscriber"

  before_filter :login_required
  before_filter :find_coupon
  
  def index
    @reservations = @coupon.reservations
  end

  def new
    session[:reservation_params] = {}  
    session[:reservation_step] = nil
    @reservation = Reservation.new(session[:reservation_params])
    @reservation.current_step = session[:reservation_step]
  end

  def create
    session[:reservation_params].deep_merge!(params[:reservation]) if params[:reservation]  
    @reservation = Reservation.new(session[:reservation_params])
    @reservation.current_step = session[:reservation_step]

    if @reservation.first_step?
      if @reservation.valid?
        @reservation.next_step
        session[:reservation_step] = @reservation.current_step
      end
      render "new"
    elsif @reservation.last_step?

      if params[:reservation][:orders_attributes].nil? || params[:reservation][:orders_attributes].size < 1
        render "new"
      elsif @reservation.valid?
        @reservation.save
        redirect_to :reservations
      else
        render "new"
      end
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
    editable_checking
    coupon_permission_checking!
  end
  
  def update
    @reservation = Reservation.find(params[:id])
    editable_checking
    coupon_permission_checking!
    if @reservation.update_attributes(params[:reservation])
      redirect_to :reservations
    else
      render :action => :edit
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    editable_checking
    coupon_permission_checking!
    @reservation.destroy
    redirect_to :reservations
  end

  def toggle_shoe_options
    wrapper_id = params[:wrapper_id]
    options = if params[:shoe_type] == "board"
                BOARD_STANCE_OPTIONS
              else
                SKI_OPTIONS
              end
    render :update do |page|
      page.replace_html "shoe_options_#{wrapper_id}", :partial => "reservations/select_shoe_options", :locals => { :shoe_options => options }
    end
  end


  protected

    def find_coupon
      @coupon = Coupon.find(session[:user_id])
      @product = @coupon.product
    end
  
    def editable_checking
      unless @reservation.editable?
        redirect_to :reservations
      end
    end
 
    def coupon_permission_checking!
      if current_user.id != @reservation.coupon.id
        redirect_to :reservations
      end
    end

end
