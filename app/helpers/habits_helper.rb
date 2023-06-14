module HabitsHelper
  def habits_completed(goal)
    completed = CompletionDate
                  .where('habit_id IN (?) AND created_at >= ?',
                         goal.habits.select(:id), Date.today.beginning_of_day).count

    all = goal.habits.count
    habits = completed == 0 ? 0 : completed
    "#{habits}/#{all}"
  end
end
