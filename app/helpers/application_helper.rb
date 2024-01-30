module ApplicationHelper
  def link_with_icon(icon_class = nil, path = nil, text = nil, **options, &)
    link_to "#{icon(icon_class)}#{t(text).capitalize if text}".html_safe, path, options, &
  end

  def delete_link_to(text = nil, path = nil, icon_class = nil, **options, &)
    link = block_given? ? text : path

    data = { data: { turbo_method: :delete, turbo_confirm: t('sure'), modal_title: t("#{options[:title]}", name: options[:name]) } }
    options = options.merge(data)

    if block_given?
      link_to(link, options, &)
    else
      link_to "#{icon(icon_class)}#{t(text) unless text.empty?}".html_safe, link, options
    end
  end

  def active_link_to(text = nil, path = nil, **options, &)
    link = block_given? ? text : path

    if current_page?(link, check_parameters: true)
      classes = 'link-icon btn btn-primary btn-sm'
    else
      classes = 'link-icon btn btn-outline-primary btn-sm'
    end

    options[:class] = class_names(options[:class], classes)

    if block_given?
      link_to(link, options, &)
    else
      link_to text, path, options
    end
  end

  def sortable(column, title = nil)
    title ||= t("#{column}")
    css_class = column == sort_column ? "current-#{sort_direction}" : nil
    icon_class = params[:sort] == column ? (params[:direction] == 'desc' ? 'bi bi-caret-down-fill' : 'bi bi-caret-up-fill') : 'bi bi-caret-up-fill'
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to "#{title} <i class='#{icon_class}'></i>".html_safe, { sort: column, direction: direction }, class: css_class
  end

  def flash_class(level)
    case level
    when :noticed then 'alert alert-success'
    when :danger then 'alert alert-danger'
    end
  end

  def user_avatar(user, size: 30, css_class: 'rounded-circle', style: '')
    if user.avatar.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, nil]), class: css_class, style: style
    else
      user.decorate.gravatar(size: size, css_class: css_class, style: style)
    end
  end

  def days_left(target)
    days = (target.deadline.to_date - Date.today).to_i

    if days.negative? || days.zero?
      0
    else
      days
    end
  end
end
