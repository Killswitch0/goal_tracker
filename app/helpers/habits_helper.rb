module HabitsHelper
  def habit_complete_link(habit, path)
    link_to "#{habit.completed_today? ? t('uncomplete_habit') : t('complete_habit')}",
            path,
            class: "btn btn-sm btn-primary action"
  end

  def habits_completed_for(target)
    completed = target.habits.completed_today.count
    all = target.habits.count
    "#{t('done')} #{content_tag(:span, completed, class: 'completed-count')} / #{all}".html_safe
  end
end
