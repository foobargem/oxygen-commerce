class Admin::ProductsController < ApplicationController

  before_filter :authenticate_admin!

  layout "admin"

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
    @product.closed_at = @product.closed_at.end_of_day
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
      @product.update_attribute(:closed_at, @product.closed_at.end_of_day)

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
    session[:current_tr_count] = 1
  end

  def create_coupons
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to admin_product_coupons_path(@product)
    else
      render :action => :new_coupons
    end
  end

  def add_coupon_fields
    @product = Product.find(params[:id])
    session[:current_tr_count] += 1
    render :update do |page|
      page.insert_html :bottom, "coupon_fields_wrapper", :partial => "admin/products/tr_form",
                        :locals => { :product => @product }
      page.toggle "add_coupon_button", "add_coupon_button_hide"
    end 
  end 

  def remove_coupon_fields
    count = params[:tr_count]
    if count.to_i > 0
      render :udpate do |page|
        page.remove "new_coupon_#{count}"
      end
    else
      render :update do |page|
      end
    end
  end

end
