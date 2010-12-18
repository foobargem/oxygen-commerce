class Admin::ReservationsController < ApplicationController

  before_filter :authenticate_admin!
  before_filter :find_product

  layout "admin"

  def index
    reservations = @product.reservations.includes(:coupon)
    @grouped_reservations = reservations.group_by(&group_by_block_statement)
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])
    if @reservation.update_attributes(params[:reservation])
      redirect_to [:admin, @product, :reservations]
    else
      render :action => :edit
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to [:admin, @product, :reservations]
  end


  protected

    def find_product
      @product = Product.find(params[:product_id])
    end


    def group_by_block_statement
      group_by = params[:groupby] || "used_at"
      block = case group_by
              when "used_at"
                Proc.new{ |r| r.used_at.to_date }
              when "agency"
                Proc.new{ |r| r.coupon.agency_name }
              when "provider"
                Proc.new{ |r| r.product.provider_name }
              end
      block
    end
  
end
