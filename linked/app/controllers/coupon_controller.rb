class CouponController < ApplicationController

  layout "subscriber"

  before_filter :login_required

  def show
    @coupon = Coupon.find(session[:user_id])
  end

  def new_reservations
    @coupon = Coupon.find(session[:user_id])
    @product = @coupon.product
    session[:current_tr_count] = 1
  end

  def create_reservations
    @coupon = Coupon.find(session[:user_id])
    if @coupon.update_attributes(params[:coupon])
      redirect_to coupon_reservations_path
    else
      redirect_to new_reservations_coupon_path
    end
  end

  def add_reservation_fields
    @coupon = Coupon.find(session[:user_id])
    @product = @coupon.product
    if @coupon.reservable? && (session[:current_tr_count] + 1) <= @coupon.usable_quantity
      session[:current_tr_count] += 1
      render :update do |page|
        page.insert_html :bottom, "reservation_fields_wrapper", :partial => "coupon/tr_form",
                        :locals => { :product => @product, :coupon => @coupon }
        page.toggle "add_user_button", "add_user_button_hide"
      end
    else
      render :update do |page|
        page.toggle "add_user_button", "add_user_button_hide"
      end
    end
  end

  def remove_reservation_fields
    @coupon = Coupon.find(session[:user_id])
    @product = @coupon.product
    if session[:current_tr_count] > 1
      render :update do |page|
        page.remove "new_reservation_#{session[:current_tr_count]}"
      end
      session[:current_tr_count] -= 1
    else
      render :update do |page|
      end
    end
  end

end
