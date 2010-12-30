# encoding: utf-8
module Admin::ProductsHelper

  def display_max_booking_limit_count(p)
    txt = []
    if p.constraints_max_booking_counts
      p.constraints_max_booking_counts.each do |k, v|
        txt << "#{RESORT_OPTIONS[k.to_s]}: #{number_with_delimiter(v)}"
      end
    end
    txt.join(", ")
  end

  def display_constraint_dates(p)
    if p.product_constraints.size < 1
      "설정된 날짜가 없습니다."
    else
      str = []
      p.product_constraints.each do |c|
        str << display_date(c.unavailabled_at)
      end
      return "(제외: " + str.join(", ") + ")"
    end
  end

end
