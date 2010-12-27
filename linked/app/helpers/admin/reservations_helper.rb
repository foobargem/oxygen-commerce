# encoding: utf-8
module Admin::ReservationsHelper

  def display_group_by_string(group_by, key)
    case group_by
    when "agency"
      "구매업체: #{key}"
    when "provider"
      "공급업체: #{key}"
    else
      "이용일: #{key}"
    end
  end

  def display_coupon_number_of_reservation(coupon)
    if coupon.nil?
      "삭제된 쿠폰입니다."
    else
      coupon.coupon_number
    end
  end

end
