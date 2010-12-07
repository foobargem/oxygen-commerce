class Admin::ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to admin_products_path
    else
      render :action => :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to admin_product_path(@product)
    else
      render :action => :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path
  end


  def new_coupons
    @product = Product.find(params[:id])
    @coupon = Coupon.new
  end

  def create_coupons
    coupon_attrs = params[:product][:coupon_attributes]
    @product = Product.find(params[:id])
    coupons = []

    coupon_attrs.each do |coupon|
      unless coupon.values.any?{ |m| m.blank? }
        coupons << coupon
      end
    end

    logger.debug "----------- #{coupons}"
    if Coupon.create(coupons)
      redirect_to admin_product_coupons_path(@product)
    else
      render :action => :new_coupons
    end
  end

end
