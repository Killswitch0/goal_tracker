module HabitsHelper
  def habits_completed(goal)
    completed = goal.habits.completed_today.count
    all = goal.habits.count
    [completed, all]
  end

  def habit_complete_link(habit, path)
    link_to "#{habit.completed_today? ? 'uncomplete' : 'complete'}",
            path,
            class: "#{habit.completed_today? ? 'btn btn-success btn-sm' : 'btn btn-warning btn-sm'}"
  end

  def all_habits
    completed = current_user.habits.completed_today.count
    all = current_user.habits.count
    [completed, all]
  end
end
