module ApplicationHelper
  def default_date_format(date)
    date.strftime("%d/%m/%y %H:%M")
  end

  def active?(filter)
    'active' if filter == @filter
  end

  def items_count(tag_name)
    Item.tagged_with(tag_name).count
  end
end
