module ApplicationHelper

  def display_date_with_time(date_time)
    unless date_time.nil?
      I18n.l(date_time)
    else
      "-"
    end
  end

end
