# encoding: utf-8
class Admin::ReservationsController < ApplicationController

  before_filter :authenticate_admin!

  layout "admin"

  def index
    reservations = scope_by_cond(Reservation.scoped).order("used_at asc, subscriber_name asc").includes(:orders, :coupon, :product)
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
    reg = ReservationsExcelGenerator.new
    reg.export_to_xls

    postfix = Time.zone.now.strftime("%Y%m%d_%H%M")
    download_filename = "예약목록_#{postfix}.xls"

    send_file(reg.output_file_path, {
      :filename => download_filename
    })
  end


  protected

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

    def scope_by_cond(scoped)
      unless params[:starts_at].blank?
        scoped = scoped.where("used_at >= ?", params[:starts_at])
      end

      unless params[:ends_at].blank?
        scoped = scoped.where("reservations.used_at <= ?", params[:ends_at])
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
