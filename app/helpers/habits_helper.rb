module HabitsHelper
  def habits_completed(goal)
    completed = goal.habits.where(keep: true).count
    all = goal.habits.count
    habits = completed == 0 ? 0 : completed
    "#{habits}/#{all}"
  end
end
