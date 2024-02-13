module ChartHelper
  def link_to_chart(goal = nil, icon_class: nil, type: nil, **options)
    path = case type
           when 'task'
             goal ? goal_task_chart_path(goal, period: 'day') : task_chart_path(period: 'day')
           else
             if goal
               goal_habit_chart_path(goal, period: 'day',
                                           chart_type: 'line')
             else
               habit_chart_path(period: 'day',
                                chart_type: 'line')
             end
           end

    link_to "#{icon(icon_class)}#{t('navigation.chart')}".html_safe, path, options
  end
end

def link_to_chart_with_data(**options)
  return unless current_user

  path = if current_user.habits.present?
           habit_chart_path(period: 'day', chart_type: 'line')
         elsif current_user.tasks.present?
           task_chart_path(period: 'day', chart_type: 'line')
         else
           habit_chart_path(period: 'day', chart_type: 'line')
         end

  link_to t('navigation.chart'), path, options
end
