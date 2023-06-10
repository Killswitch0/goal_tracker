module HabitsHelper
  def habits_completed(goal)
    habits = goal.habits.where(keep: true).count
    habits == 0 ? 0 : habits
  end
end
