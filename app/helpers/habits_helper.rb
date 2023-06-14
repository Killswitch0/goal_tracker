module HabitsHelper
  def habits_completed(goal)
    completed = goal.habits.completed(goal).count
    all = goal.habits.count
    "#{completed}/#{all}"
  end
end
