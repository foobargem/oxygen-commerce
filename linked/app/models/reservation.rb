class Reservation < ActiveRecord::Base

  belongs_to :coupon, :counter_cache => true
  belongs_to :product

  validates_presence_of :user_name, :resort, :height, :shoe_size
  validates_presence_of :board_stance, :if => :board_type?

  def board_type?
    shoe_type == "board"
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
      if record.coupon.quantity.to_i < record.coupon.reservations_count.to_i + 1
        record.errors[attribute] << "Quantity exceeded"
      end
    end
  end

  validates :coupon_id, :coupon_limit_quantity => true, :on => :create


end
