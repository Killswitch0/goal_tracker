module HabitsHelper
  def habits_completed(goal)
    completed = goal.habits.completed_today.count
    all = goal.habits.count
    "#{completed}/#{all}"
  end
end
