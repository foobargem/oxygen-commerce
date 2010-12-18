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

  def shoe_type_options_collection
    SHOE_TYPE_OPTIONS.map{ |k, v| [v, k] }
  end

  def board_stance_options_collection
    BOARD_STANCE_OPTIONS
  end

  def part_time_options_collection
    PART_TIME_OPTIONS.map{ |k, v| [v, k] }
  end

end
