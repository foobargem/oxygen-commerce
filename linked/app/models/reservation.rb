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
  has_many :orders, :dependent => :destroy
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

  def prev_step
    self.current_step = steps[steps.index(current_step) - 1]
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

  def reservable_date?
    cday = Date.today.cwday
    cweek = Date.today.cweek
    current_hour = Time.zone.now.hour

    if self.product.closed_at.to_date < self.used_at.to_date
      return false
    end

    if current_hour < 12 && !([6, 7].include?(cday))
      true
    else
      dt_cday = self.used_at.to_date.cwday
      dt_cweek = self.used_at.to_date.cweek

      if [6, 7].include?(dt_cday) && cweek == dt_cweek
        false
      elsif 1 == dt_cday && (self.used_at.to_date - Date.today).to_i < 7
        false
      else
        true
      end
    end
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



  class UnavailableDateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unavailabled_dates = record.product.product_constraints.map{ |pc| pc.unavailabled_at.to_date }
      if unavailabled_dates.include?(value.to_date)
        record.errors[attribute] << "Unavailabled. Please select another day."
      end
      unless record.reservable_date?
        record.errors[attribute] << "Unreservabled. Please select another day."
      end
    end
  end
  validates :used_at, :unavailable_date => true



  class DailyOrdersLimitValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      orders_count = record.product.daily_reserved_orders_count(record.used_at.to_date)
      if record.product.daily_reservations_limit.to_i < (orders_count + value.to_i)
        record.errors[attribute] << "Exceeded daily order limit."
      end
    end
  end
  validates :booking_number, :daily_orders_limit => true

end
