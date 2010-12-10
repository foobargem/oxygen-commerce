require 'test_helper'

class ReservationTest < ActiveSupport::TestCase

  test "should raised exceeded coupon's quantity" do
    c = coupons(:one)
    reservation = Reservation.new(:coupon_id => c.id)
    reservation.user_name = "foo"
    reservation.resort = "bar resort"
    reservation.height = "90"
    reservation.shoe_size = "30"

    assert_raise ActiveRecord::RecordInvalid do
      reservation.save!
    end
  end

end
