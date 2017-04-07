module ApplicationHelper
  def default_date_format(date)
    date.strftime("%d/%m/%y %H:%M")
  end
end
