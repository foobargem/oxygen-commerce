module ReservationsHelper

  def display_shoe_type(shoe_type)
    if SHOE_TYPE_OPTIONS.has_key?(shoe_type)
      SHOE_TYPE_OPTIONS[shoe_type]
    else
      ""
    end
  end

  def date_validates
    if Time.zone.now.hour < 12
      "date > (new Date(#{Date.today.year}, #{Date.today.month - 1}, #{Date.today.day})).stripTime()"
    else
      "date > (new Date(#{Date.tomorrow.year}, #{Date.tomorrow.month - 1}, #{Date.tomorrow.day})).stripTime()"
    end
  end

  def errors_about_orders(errors)
    errors.select do |key, values|
      k = key.to_s.split('.').last.to_sym
      { k => values } if key.to_s[0..5] == "orders"
    end
  end

  def display_resort_name(resort)
    if RESORT_OPTIONS.has_key?(resort)
      RESORT_OPTIONS[resort]
    else
      ""
    end
  end

end
