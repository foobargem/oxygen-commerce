class Admin::CouponsController < ApplicationController

  before_filter :find_product

  def index
    @coupons = @product.coupons
  end

  def show
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(params[:coupon])
    render :text => params[:coupon]
#    if @coupon.save
#      redirect_to admin_product_coupons_path(@product)
#    else
#      render :action => :new
#    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    if @coupon.update_attributes(params[:coupon])
      redirect_to admin_product_coupons_path(@product)
    else
      render :action => :edit
    end
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy
    redirect_to admin_product_coupons_path
  end


  protected

    def find_product
      @product = Product.find(params[:product_id])
    end

end