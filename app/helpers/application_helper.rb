module ApplicationHelper
  def date(date)
    date.strftime("%d/%m/%y %H:%M")
  end
end
