module TasksHelper
  def task_complete_link(task, path)
    link_to "#{task.complete? ? t('uncomplete_task') : t('complete_task')}",
            path,
            class: 'btn btn-primary btn-sm action'
  end

  def tasks_completed_for(target)
    completed = target.tasks.where(complete: true).count
    all = target.tasks_count
    "#{t('done')} #{content_tag(:span, completed, class: 'completed-count')} / #{all}".html_safe
  end
end
