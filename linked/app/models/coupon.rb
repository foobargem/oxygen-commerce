# == Schema Information
# Schema version: 20101221054709
#
# Table name: coupons
#
#  id             :integer(4)      not null, primary key
#  product_id     :integer(4)
#  coupon_number  :string(255)
#  quantity       :integer(4)      default(0)
#  orders_count   :integer(4)      default(0)
#  purchaser_name :string(255)
#  phone_number   :string(255)
#  agency_name    :string(255)
#  locked_at      :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

class Coupon < ActiveRecord::Base

  belongs_to :product

  has_many :reservations
  has_many :orders

  #accepts_nested_attributes_for :reservations


  validates_presence_of :coupon_number, :purchaser_name, :phone_number
  validates_presence_of :agency_name
  validates_uniqueness_of :coupon_number, :scope => :agency_name



  def self.authorize_by_coupon_and_purchaser(params)
    if coupon = Coupon.where("coupon_number = ? AND purchaser_name = ?",
                              params[:coupon_number],
                              params[:purchaser_name]).first
      return coupon
    end
    nil
  end


  def locked?
    !!self.locked_at
  end

  def usable_quantity
    if self.product.free_type_ticket?
      1
    else
      self.quantity - self.orders_count
    end
  end

  def reservable?
    usable_quantity > 0
  end

end
