class Admin::ConstraintsController < ApplicationController

  before_filter :authenticate_admin!
  before_filter :find_product

  layout "admin"

  def index
    @constraints = @product.product_constraints.order("unavailabled_at asc")
    @constraint = ProductConstraint.new
  end

  def create
    @constraint = ProductConstraint.new(params[:product_constraint])
    if @constraint.save
      render :update do |page|
        page.insert_html :bottom, :constraints_wrapper, :partial => "admin/constraints/tr_constraint", :locals => { :constraint => @constraint }
      end
    else
      render :update do |page|
      end
    end
  end

  def destroy
    @constraint = ProductConstraint.find(params[:id])
    @constraint.destroy
    render :update do |page|
      page.remove dom_id(@constraint)
    end
  end

  protected

    def find_product
      @product = Product.find(params[:product_id])
    end

end
