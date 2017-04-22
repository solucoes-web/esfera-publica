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

  def interaction_filters
    [:bookmarks, :favourites, :history]
  end

  def exclusive_filters
    interaction_filters + [:tag, :feed]
  end

  def cumulative_filters
    [:search, :calendar]
  end

  def filters
    exclusive_filters + cumulative_filters
  end

  def safe_params(params)
    # para cada filtro pego o parametro correspondente
    hash = Hash[filters.collect{ |f| [f, params[f]]}]
    # removo aqueles cujo parametro é nulo
    hash.reject{|k,v| v.blank? }
  end

  def link_to_interaction_filter(params, interaction_type, &block)
    filter = interaction_type.to_s
    new_param = {interaction_type => true}
    link_to_filter('items_path', params, filter, new_param, interaction_type, &block)
  end

  def link_to_tag_filter(path, params, tag, &block)
    filter = tag
    new_param = {tag: tag}
    link_to_filter(path, params, filter, new_param, &block)
  end

  def link_to_filter(path, params, filter, new_param = nil, id = nil)
    # acrecento um novo parâmetro referente ao filtro exclusivo se existir
    hash = new_param || Hash.new
    # incluo os parametros dos filtros cumulativos que existirem
    cumulative_filters.each do |f|
      hash[f] = params[f] unless params[f].blank?
    end

    active = 'active' if filter == @filter
    css = { class: "list-group-item #{active}" }
    css.merge!(id: id) if id

    link_to send(path, hash), css do
      yield
    end
  end

  def link_to_clear_filter(path, type, params)
    hash = safe_params(params).except(type)

    link_to send(path, hash), class: "btn btn-default #{"disabled" unless params[type]}" do
      yield
    end
  end

  def interaction_icon(type, icon, user, item)
    # pega a interação ligando o usuario ao item
    inter = Interaction.find_by(user: user, item: item)
    # verifica se é ativa
    active = 'active' if inter && inter.send(type.to_s + '?')
    # link para toggle da interação com um ícone
    link_to item_path(item, type => :toggle), method: :patch do
      content_tag :span, "", class: "glyphicon glyphicon-#{icon} interaction #{active}"
    end
  end
end
