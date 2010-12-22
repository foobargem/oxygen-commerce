module ApplicationHelper

  def display_date_with_time(date_time)
    unless date_time.nil?
      I18n.l(date_time)
    else
      "-"
    end
  end

  def display_date(date)
    unless date.nil?
      I18n.l(date.to_date)
    else
      "-"
    end
  end


  # options of select
  def shoe_type_options_collection
    SHOE_TYPE_OPTIONS.map{ |k, v| [v, k] }
  end

  def board_stance_options_collection
    BOARD_STANCE_OPTIONS
  end

  def ski_options_collection
    SKI_OPTIONS
  end

  def part_time_options_collection
    PART_TIME_OPTIONS.map{ |k, v| [v, k] }
  end

  def ticket_type_options_collection
    TICKET_TYPE_OPTIONS.map{ |k, v| [v, k] }
  end

  def resort_options_collection
    RESORT_OPTIONS.map{ |k, v| [v, k] }
  end

  def resort_collection_by_ticket(product)
    if product.free_type_ticket?
      resort_options_collection
    else
      {RESORT_OPTIONS[product.resort] => product.resort}
    end
  end

  def display_resort(product)
    if product.free_type_ticket?
      RESORT_OPTIONS.values.join(",")
    elsif RESORT_OPTIONS.has_key?(product.resort)
      RESORT_OPTIONS[product.resort]
    else
      ""
    end
  end

  def display_ticket_type(ticket_type)
    if TICKET_TYPE_OPTIONS.has_key?(ticket_type)
      TICKET_TYPE_OPTIONS[ticket_type]
    else
      ""
    end
  end

  def display_resort_info(resort, key)
    RESORTS[resort][key]
  end

end
