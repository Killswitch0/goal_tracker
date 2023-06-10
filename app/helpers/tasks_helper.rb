module TasksHelper
  def tasks_complete(goal)
    completed = goal.tasks.where(complete: true).count
    all = goal.tasks.count
    completed == 0 ? 0 : completed
    "#{completed}/#{all}"
  end
end
