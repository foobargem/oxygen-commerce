class Reservation < ActiveRecord::Base
  has_one :coupon
end
