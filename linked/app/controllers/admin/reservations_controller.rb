# encoding: utf-8
class Admin::ReservationsController < ApplicationController

  before_filter :authenticate_admin!
  before_filter :find_coupon_with_product, :only => [:new, :create]

  layout "admin"

  def index
    params[:starts_at] ||= Date.today.strftime("%Y-%m-%d")
    reservations = scope_by_cond(Reservation.scoped.valid).order("used_at asc, subscriber_name asc, reservations.resort asc").includes(:orders, :coupon, :product)
    @grouped_reservations = reservations.group_by(&group_by_block_statement)
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    session[:reservation_params] = {}  
    session[:reservation_step] = nil
    @reservation = Reservation.new(session[:reservation_params])
    @reservation.current_step = session[:reservation_step]
    @reservation.user_role = "admin"
  end

  def create
    session[:reservation_params].deep_merge!(params[:reservation]) if params[:reservation]  
    @reservation = Reservation.new(session[:reservation_params])
    @reservation.current_step = session[:reservation_step]
    @reservation.user_role = "admin"

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
        redirect_to [:admin, :reservations]
      else
        render "new"
      end
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
    @product = @reservation.product
  end

  def update
    @reservation = Reservation.find(params[:id])
    if @reservation.update_attributes(params[:reservation])
      redirect_to [:admin, :reservations]
    else
      render :action => :edit
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to [:admin, @product, :reservations]
  end

  def export_to_excel
    params[:starts_at] ||= Date.today.beginning_of_day
    @reservations = scope_by_cond(Reservation.scoped.valid).order("used_at asc, subscriber_name asc, reservations.resort asc").includes(:orders, :coupon, :product)
    @reservations = @reservations.where("product_id is not null or coupon_id is not null")

    reg = ReservationsExcelGenerator.new(@reservations)
    reg.export_to_xls

    postfix = Time.zone.now.strftime("%Y%m%d_%H%M")
    download_filename = "예약목록_#{postfix}.xls"

    send_file(reg.output_file_path, {
      :filename => download_filename,
      :type => "application/vnd.ms-excel;charset=utf-8"
    })
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

    def find_coupon_with_product
      @coupon = Coupon.find(params[:coupon_id])
      @product = @coupon.product
    end

    def find_product
      @product = Product.find(params[:product_id])
    end


    def group_by_block_statement
      group_by = params[:groupby] || "used_at"
      block = case group_by
              when "agency"
                Proc.new{ |r| r.coupon.agency_name }
              when "product"
                Proc.new{ |r| r.product.name }
              when "resort"
                Proc.new{ |r| r.resort }
              else
                Proc.new{ |r| r.used_at.to_date }
              end
      block
    end

    def scope_by_cond(scoped)
      unless params[:starts_at].blank?
        if params[:starts_at] =~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/
          scoped = scoped.where("used_at >= ?", params[:starts_at].to_date.beginning_of_day)
        end
      end

      unless params[:ends_at].blank?
        if params[:ends_at] =~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/
          scoped = scoped.where("reservations.used_at <= ?", params[:ends_at].to_date.end_of_day)
        end
      end

      unless params[:created_at].blank?
        if params[:created_at] =~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/
          scoped = scoped.where("reservations.created_at >= ? AND reservations.created_at <= ?",
                                params[:created_at].to_date.beginning_of_day,
                                params[:created_at].to_date.end_of_day)
        end
      end

      unless params[:resort].blank?
        scoped = scoped.where("reservations.resort in (?)", params[:resort])
      end

      unless params[:user_name].blank?
        scoped = scoped.where("orders.user_name like ?", "%#{params[:user_name]}%")
      end

      unless params[:coupon_number].blank?
        scoped = scoped.where("coupons.coupon_number = ?", params[:coupon_number])
      end
      scoped
    end

end
