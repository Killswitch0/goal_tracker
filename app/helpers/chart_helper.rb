module ChartHelper
  def link_to_chart(goal = nil, icon_class: nil, type: nil, **options)
    path = case type
           when 'task'
             goal ? goal_task_chart_path(goal, period: 'day') : task_chart_path(period: 'day')
           else
             goal ? goal_habit_chart_path(goal, period: 'day', chart_type: 'line') : habit_chart_path(period: 'day', chart_type: 'line')
           end

    link_to "#{icon(icon_class)}#{t('navigation.chart')}".html_safe, path, options
  end
end
