module HabitsHelper
  def habits_completed(goal)
    completed = goal.habits.completed_today.count
    all = goal.habits.count
    "#{completed}/#{all}"
  end

  def habit_complete_link(habit)
    link_to "#{habit.completed_today? ? 'uncomplete' : 'complete'}",
            complete_habit_path(habit),
            class: "#{habit.completed_today? ? 'btn btn-success btn-sm' : 'btn btn-warning btn-sm'}"
  end
end
