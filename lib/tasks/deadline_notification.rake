namespace :deadline_notifications do
  desc 'TODO'
  task goal_deadline_notify: :environment do
    GoalDeadlineJob.perform_async
  end

  task task_deadline_notify: :environment do
    TaskDeadlineJob.perform_async
  end
end
