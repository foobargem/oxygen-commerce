class Admin::ResortsController < ApplicationController

  before_filter :authenticate_admin!

  layout "admin"

  def index
    @resorts = Resort.scoped
  end

  def show
  end

  def edit
    @resort = Resort.find(params[:id])
  end

  def update
    @resort = Resort.find(params[:id])
    if @resort.update_attributes(params[:resort])
      redirect_to [:admin, :resorts]
    else
      render :edit
    end
  end

end
