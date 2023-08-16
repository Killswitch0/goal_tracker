module TasksHelper
  def tasks_complete(goal)
    completed = goal.tasks.where(complete: true).count
    all = goal.tasks.count
    [completed, all]
  end

  def task_complete_link(task)
    link_to "#{task.complete? ? 'Unfinished task' : 'Finish task'}",
            complete_goal_task_path(task),
            class: "btn btn-primary btn-sm"
  end

  def all_tasks
    completed = current_user.tasks.where(complete: true).count
    all = current_user.tasks.count
    [completed, all]
  end
end
