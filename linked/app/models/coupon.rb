class Coupon < ActiveRecord::Base

  belongs_to :product
  has_many :reservations

  validates_presence_of :coupon_number, :purchaser_name, :phone_number
  validates_presence_of :agency_name


  def self.authorize_by_coupon_and_purchaser(params)
    if coupon = Coupon.find(:first,
                            "coupon_number = ? AND purchaser_name = ?",
                            params[:coupon_number],
                            params[:purchaser_name])
      return coupon
    end
    nil
  end


  def usable_quantity
    self.quantity - self.reservations_count
  end

end
