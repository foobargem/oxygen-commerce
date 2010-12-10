class Reservation < ActiveRecord::Base

  belongs_to :coupon, :counter_cache => true

end
