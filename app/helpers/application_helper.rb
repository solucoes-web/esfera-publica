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

  def human_readable_number(n)
    n > 1000 ? "#{(n.to_f/1000).round(1)} K" : n
  end

  def pluralize(string, number)
    number == 1 ? "1 #{string}" : "#{number} #{string}s"
  end

  def filter_active?(filter)
    'active' if filter == @filter
  end

  def active?(user, item, type)
    inter = Interaction.find_by(user: user, item: item)
    'active' if inter && inter.send("#{type}?") 
  end

  def safe_params(options = [:tag, :feed, :date, :search], hash = {}, params)
    options.each do |option|
      hash[option] = params[option] unless params[option].blank?
    end
    hash
  end
end
