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

end
