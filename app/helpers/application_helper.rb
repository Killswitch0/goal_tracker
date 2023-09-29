module ApplicationHelper
  include BootstrapHelper

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
