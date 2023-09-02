module HabitsHelper
  def habit_complete_link(habit, path)
    link_to "#{habit.completed_today? ? t('uncomplete_habit') : t('complete_habit')}",
            path,
            class: "#{habit.completed_today? ? 'btn btn-success btn-sm' : 'btn btn-warning btn-sm'}"
  end

  def habits_completed_for(target)
    completed = target.habits.completed_today.count
    all = target.habits.count
    [completed, all]
  end
end
