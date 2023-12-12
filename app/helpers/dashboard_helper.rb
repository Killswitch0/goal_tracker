module DashboardHelper
  def calculate_tasks(goal: nil, user:)
    completed_tasks = user.tasks.where(complete: true)
    completed_tasks = completed_tasks.where(goal:) if goal
    completed_tasks = completed_tasks.count

    calculate_percentage(completed_tasks, 'tasks', goal:, user:)
  end

  def calculate_habits
    completed_habits = current_user.habits.completed_today.count
    calculate_percentage(completed_habits, 'habits', user: current_user)
  end


  def calculate_percentage(completed_items, items, goal: nil, user: nil)
    user_items = user.send(items.to_sym)
    user_items = user_items.where(goal:) if goal
    total_items = user_items.count

    return 0 if total_items.zero?

    (completed_items.to_f / total_items * 100).round
  end
end
