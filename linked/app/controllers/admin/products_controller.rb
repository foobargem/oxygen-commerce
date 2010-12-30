# encoding: utf-8
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

  def edit_booking_constraints
    @product = Product.find(params[:id])
  end

  def update_booking_constraints
    @product = Product.find(params[:id])

    consts = {}
    if @product.free_type_ticket?
      RESORT_OPTIONS.keys.each_with_index do |k, i|
        consts.store(:"#{k}", params[:product][:constraints_max_booking_counts][i].to_i)
      end
    else
      consts.store(:"#{@product.resort}", params[:product][:constraints_max_booking_counts].to_i)
    end

    if @product.update_attribute(:constraints_max_booking_counts, consts)
      redirect_to [:admin, :products]
    else
      render :edit_booking_constraints
    end
  end




  def new_coupons
    flash[:error_message] = nil
    @product = Product.find(params[:id])
    coupon = @product.coupons.build
    @coupons = [coupon]
    session[:current_tr_count] = 1
  end

  def create_coupons
    @product = Product.find(params[:id])

    coupons = []
    invalid_coupons = []
    params[:product][:coupons_attributes].each do |coupon|
      c = Coupon.new(coupon)
      unless c.valid?
        invalid_coupons << coupon
      else
        coupons << coupon
      end
    end

    if @product.update_attributes(params[:product])
      redirect_to admin_product_coupons_path(@product)
    else
      @coupons = []
      flash[:error_message] = "등록실패"

      invalid_coupons.each do |coupon|
        flash[:error_message] << '\n'
        flash[:error_message] << " - 쿠폰번호 중복: #{coupon[:coupon_number]}"
      end

      params[:product][:coupons_attributes].each do |coupon_attrs|
        @coupons << @product.coupons.build(coupon_attrs)
      end
      render :action => :new_coupons
    end
  end

  def add_coupon_fields
    @product = Product.find(params[:id])
    session[:current_tr_count] += 1
    render :update do |page|
      page.insert_html :bottom, "coupon_fields_wrapper", :partial => "admin/products/new_coupon",
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

  def new_coupons_from_import
    @product = Product.find(params[:id])
    @coupon = Coupon.new
    session[:current_tr_count] = 1
  end

  def new_import
    @product = Product.find(params[:id])
    render :partial => "admin/products/new_import", :locals => { :product => @product }
  end

  def import_from_excel_file
    @product = Product.find(params[:id])
    excel_file = params[:excel_file]
    unless excel_file.nil?

      case File.extname(excel_file.original_filename)
      when ".xls"
        src_filename = "#{excel_file.tempfile.path}.xls"
        excel_klass = Excel
      when ".xlsx"
        src_filename = "#{excel_file.tempfile.path}.xlsx"
        excel_klass = Excelx
      end

      File.rename(excel_file.tempfile.path, src_filename)

      excel = excel_klass.new(src_filename)

      rows = (2..excel.last_row).to_a

      respond_to_parent do
        render :update do |page|

          (2..excel.last_row).to_a.each do |row_no|
            session[:current_tr_count] += 1

            coupon = Coupon.new(
              :coupon_number => excel.cell(row_no, 1).to_s.force_encoding("utf-8").strip,
              :quantity => excel.cell(row_no, 2).to_s.force_encoding("utf-8").strip,
              :purchaser_name => excel.cell(row_no, 3).to_s.force_encoding("utf-8").strip,
              :phone_number => excel.cell(row_no, 4).to_s.force_encoding("utf-8").strip,
              :agency_name => excel.cell(row_no, 5).to_s.force_encoding("utf-8").strip
            )

            page.insert_html :bottom, "coupon_fields_wrapper", :partial => "admin/products/tr_form",
                             :locals => { :product => @product, :coupon => coupon }

            page << "facebox.close();"
          end
        end 
      end
    else
      respond_to_parent do
        render :update do |page|
          page << "facebox.close();"
        end
      end
    end
  end


end
