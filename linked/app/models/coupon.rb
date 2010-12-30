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

  has_many :reservations, :dependent => :nullify
  has_many :orders, :dependent => :nullify

  #accepts_nested_attributes_for :reservations


  validates_presence_of :coupon_number, :purchaser_name, :phone_number
  validates_presence_of :agency_name
  validates_uniqueness_of :coupon_number




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

  def reservable_date?(dt)
    if self.product.free_type_ticket?
      if dt.nil?
        return false
      end
      if self.reservations.select{ |r| r.used_at.to_date == dt.to_date }.size > 0
        return false
      end
    end
    true
  end

  def unavailable_dates_by_continuous_reservations
    unavailable_dates = []
    if self.product.free_type_ticket?
      dates = self.reservations.map{ |r| r.used_at.to_date }

      cnt = 1

      dates.each_with_index do |d, i|
        if i < dates.size - 1
          if (d.to_time.to_i + 1.day) == dates[i + 1].to_time.to_i
            cnt += 1
          else
            cnt = 1
          end

          if cnt == 3
            unavailable_dates << (dates[i + 1] + 1.day).to_date
            unavailable_dates << (dates[i + 1] + 2.days).to_date
            unavailable_dates << (dates[i + 1] + 3.days).to_date
          end

        end
      end

    end
    unavailable_dates
  end

end
