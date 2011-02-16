# == Schema Information
# Schema version: 20101221054709
#
# Table name: reservations
#
#  id              :integer(4)      not null, primary key
#  coupon_id       :integer(4)
#  product_id      :integer(4)
#  subscriber_name :string(255)
#  booking_number  :integer(4)
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


  scope :valid, where("reservations.coupon_id is not null")


  attr_writer :user_role

  def user_role
    @user_role || "user"
  end

  def validation_bypass?
    @user_role == "admin"
  end


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
    today = Date.today
    cday = today.cwday
    cweek = today.cweek
    current_hour = Time.zone.now.hour

    if self.product.closed_at.to_date < self.used_at.to_date
      return false
    end

    if (current_hour < 12) && !([6, 7].include?(cday))
      return true
    else
      dt = self.used_at
      dt_cday = dt.to_date.cwday
      dt_cweek = dt.to_date.cweek

      if current_hour > 12 && cday == 5
        if [today + 1.day, today + 2.days, today + 3.days].include?(dt.to_date)
          return false
        end
      end

      if cday == 6
        if [today + 1.day, today + 2.days].include?(dt.to_date)
          return false
        end
      end

      if cday == 7
        if [today + 1.day].include?(dt.to_date)
          return false
        end
      end

      return true
    end
  end


  class CouponLimitQuantityValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless record.product.free_type_ticket?
        if record.coupon.quantity.to_i < record.coupon.orders_count.to_i + 1
          record.errors[attribute] << I18n.t(:quantity_exceeded, :scope => [:activerecord, :errors, :messages])
        end
        if record.coupon.usable_quantity < value.to_i
          record.errors[attribute] << I18n.t(:quantity_exceeded, :scope => [:activerecord, :errors, :messages])
        end
      end
    end
  end
  validates :booking_number, :coupon_limit_quantity => true, :on => :create



  class UnavailableDateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unavailabled_dates = record.product.product_constraints.map{ |pc| pc.unavailabled_at.to_date }
      if unavailabled_dates.include?(value.to_date)
        record.errors[attribute] << I18n.t(:unavailabled, :scope => [:activerecord, :errors, :messages])
      end
      unless record.reservable_date?
        p " NONONONONONO"
        record.errors[attribute] << I18n.t(:unavailabled, :scope => [:activerecord, :errors, :messages])
      end
    end
  end

  validates :used_at, :unavailable_date => true,
                      :unless => Proc.new{ |m| m.used_at_is_nil? || m.validation_bypass? }


  class ContinuousReservationValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unavailable_dates = record.coupon.unavailable_dates_by_continuous_reservations(value.to_date)
      if unavailable_dates.include?(value.to_date)
        record.errors[attribute] << I18n.t(:continuous_reservation, :scope => [:activerecord, :errors, :messages])
      end
    end
  end

  validates :used_at, :continuous_reservation => true,
                      :unless => Proc.new{ |m| m.used_at_is_nil? || m.validation_bypass? }



  class OnedayReservableValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless record.coupon.reservable_date?(value)
        record.errors[attribute] << I18n.t(:oneday_reservable_limit_exceeded, :scope => [:activerecord, :errors, :messages])
      end
    end
  end

  validates :used_at, :oneday_reservable => true,
                      :if => Proc.new{ |m| m.free_ticket_and_new_record? && !m.validation_bypass? }


  def free_ticket_and_new_record?
    self.product.free_type_ticket? && self.new_record?
  end


  class DailyOrdersLimitValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      orders_count = record.product.daily_reserved_orders_count(record.used_at.to_date)

      if record.new_record?
        plus_value = value.to_i
      else
        old_record = Reservation.find(record.id)
        plus_value = if old_record.used_at == record.used_at
                       0
                     else
                       value.to_i
                     end
      end
      
      resort = Resort.find_by_name(record.resort)

      if resort.oneday_booking_limit_count.to_i < (orders_count + plus_value)
        record.errors[attribute] << I18n.t(:unreservabled, :scope => [:activerecord, :errors, :messages])
      end
    end
  end
  validates :booking_number, :daily_orders_limit => true,
            :if => Proc.new{ |m| m.booking_number_validatable? && !m.validation_bypass? }




  def used_at_is_nil?
    self.used_at.nil?
  end

  def booking_number_validatable?
    !self.used_at.blank? && !self.resort.blank?
  end

end
