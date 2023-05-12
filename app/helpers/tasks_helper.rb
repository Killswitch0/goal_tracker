module TasksHelper
  def tasks_complete(goal)
    tasks = goal.tasks.where(complete: true).count
    tasks == 0 ? 0 : tasks
  end
end
