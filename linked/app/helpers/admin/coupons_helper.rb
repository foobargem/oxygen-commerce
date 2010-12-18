# encoding: utf-8
module Admin::CouponsHelper

  def display_coupon_locked(c)
    if c.locked?
      "정지"
    else
      "정상"
    end
  end

end
