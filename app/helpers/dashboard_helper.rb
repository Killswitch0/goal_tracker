module DashboardHelper
  def calculate_items(goal: nil, user:)
    completed_tasks = if goal
                        user.tasks.where(complete: true, goal:).count
                      else
                        user.tasks.where(complete: true).count
                      end
    calculate_percentage(completed_tasks, 'tasks', goal:, user:)
  end

  def calculate_habits
    completed_habits = current_user.habits.completed_today.count
    calculate_percentage(completed_habits, 'habits', user: current_user)
  end


  def calculate_percentage(completed_items, items, goal: nil, user: nil)
    total_items ||= if goal
                      user.send(items.to_sym).where(goal:).count
                    else
                      user.send(items.to_sym).count
                    end

    return 0 if total_items.zero?

    (completed_items.to_f / total_items * 100).round
  end
end
