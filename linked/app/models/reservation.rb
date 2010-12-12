class Reservation < ActiveRecord::Base

  belongs_to :coupon, :counter_cache => true

  validates_presence_of :user_name, :resort, :height, :shoe_size
  validates_presence_of :board_stance, :if => :board_type?

  def board_type?
    shoe_type == "board"
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
