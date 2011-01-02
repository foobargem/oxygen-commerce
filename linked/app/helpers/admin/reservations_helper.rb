# encoding: utf-8
module Admin::ReservationsHelper

  def display_group_by_string(group_by, key)
    case group_by
    when "agency"
      "구매업체: #{key}"
    when "product"
      "상품명: #{key}"
    when "resort"
      "스키장: #{RESORT_OPTIONS[key]}"
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

  def display_contact(phone_number)
    unless phone_number.nil?
      phone_number
    end
  end

end
