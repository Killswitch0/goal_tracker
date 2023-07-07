module TasksHelper
  def tasks_complete(goal)
    completed = goal.tasks.where(complete: true).count
    all = goal.tasks.count
    completed == 0 ? 0 : completed
    "#{completed}/#{all}"
  end

  def task_complete_link(task)
    link_to "#{task.complete? ? 'Unfinished task' : 'Finish task'}",
            complete_task_path(task),
            class: "btn btn-primary btn-sm"
  end
end
