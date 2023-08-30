module DashboardHelper
  def calculate_items(goal = nil)
    completed_tasks = if goal
                        current_user.tasks.where(complete: true, goal:).count
                      else
                        current_user.tasks.where(complete: true).count
                      end
    calculate_percentage(completed_tasks, 'tasks', goal)
  end

  def calculate_habits
    completed_habits = current_user.habits.completed_today.count
    calculate_percentage(completed_habits, 'habits')
  end


  def calculate_percentage(completed_items, items, goal = nil)
    total_items ||= if goal
                      current_user.send(items.to_sym).where(goal:).count
                    else
                      current_user.send(items.to_sym).count
                    end

    return 0 if total_items.zero?

    (completed_items.to_f / total_items * 100).round(2)
  end
end
