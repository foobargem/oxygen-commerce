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

end
