# == Schema Information
# Schema version: 20101218012805
#
# Table name: reservations
#
#  id              :integer(4)      not null, primary key
#  coupon_id       :integer(4)
#  product_id      :integer(4)
#  subscriber_name :string(255)
#  booking_number  :integer(4)      default(0)
#  used_at         :datetime
#  part_time       :string(255)
#  resort          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Reservation < ActiveRecord::Base

  belongs_to :product
  belongs_to :coupon
  has_many :orders
  accepts_nested_attributes_for :orders


  validates_presence_of :subscriber_name, :booking_number,
                        :used_at, :part_time, :resort

  validates_numericality_of :booking_number


  attr_writer :current_step

  def current_step
    @current_step || steps.first
  end

  def steps
    ["reservation", "orders"]
  end

  def next_step
    self.current_step = steps[steps.index(current_step) + 1]
  end

  def first_step?
    self.current_step == steps.first
  end

  def last_step?
    self.current_step == steps.last
  end



  def editable?
    cday = self.used_at.to_date.cwday
    ago_days = case cday
               when 7
                 2.days
               when 1
                 3.days
               else
                 1.day
               end
    Time.zone.now < self.used_at.to_date.ago(ago_days).change(:hour => 12)
  end

  class CouponLimitQuantityValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless record.product.free_type_ticket?
        if record.coupon.quantity.to_i < record.coupon.orders_count.to_i + 1
          record.errors[attribute] << "Quantity exceeded"
        end
        if record.coupon.usable_quantity < value.to_i
          record.errors[attribute] << "Quantity exceeded"
        end
      end
    end
  end
  validates :booking_number, :coupon_limit_quantity => true, :on => :create



  #class DailyReservationsLimitValidator < ActiveModel::EachValidator
    #def validate_each(record, attribute, value)
      #if record.product.daily_reservations_limit.to_i < record.coupon.reservations_count.to_i + 1
        #record.errors[attribute] << "Quantity exceeded"
      #end
    #end
  #end

end
