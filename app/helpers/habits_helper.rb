module HabitsHelper
  def keep?
    keep == true
  end

  def habits_complete(goal)
    habits = goal.habits.where(keep: true).count
    habits == 0 ? 0 : habits
  end
end
