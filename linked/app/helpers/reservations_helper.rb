module ReservationsHelper

  def display_shoe_type(shoe_type)
    if SHOE_TYPE_OPTIONS.has_key?(shoe_type)
      SHOE_TYPE_OPTIONS[shoe_type]
    else
      ""
    end
  end

end
