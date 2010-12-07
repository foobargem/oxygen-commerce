class Coupon < ActiveRecord::Base

  belongs_to :product

  validates_presence_of :coupon_number, :purchaser_name, :phone_number
  validates_presence_of :agency_name

end
