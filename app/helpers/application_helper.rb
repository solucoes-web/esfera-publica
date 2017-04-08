module ApplicationHelper
  def default_date_format(date)
    if date
      delay_seconds = Time.now - date
      delay_minutes = delay_seconds/60
      delay_hours = delay_minutes/60
      delay_days = delay_hours/24

      if delay_minutes < 1
        return pluralize("segundo", delay_seconds.round(0))
      elsif delay_hours < 1
        return pluralize("minuto", delay_minutes.round(0))
      elsif delay_days < 1
        return pluralize("hora", delay_hours.round(0))
      elsif delay_days < 7
        return pluralize("dia", delay_days.round(0))
      else
        date.strftime("%d/%m/%y")
      end
    end
  end

  def pluralize(string, number)
    number == 1 ? "1 #{string}" : "#{number} #{string}s"
  end

  def active?(filter)
    'active' if filter == @filter
  end
end
