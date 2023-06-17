module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current-#{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, class: css_class
  end

  def flash_class(level)
    case level
    when :noticed then 'alert alert-success'
    when :danger then 'alert alert-danger'
    end
  end

  def habits_for
    @habits.left_outer_joins(:completion_dates)
           .where(completion_dates: { id: nil }) | @habits.left_joins(:completion_dates)
                                                          .where.not(completion_dates: { id: nil })
  end
end
