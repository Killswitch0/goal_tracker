class TaskDeadlineJob
  include Sidekiq::Job

  include ApplicationHelper

  queue_as :default

  def perform(*_args)
    @tasks = Task.where('deadline > ?', Time.now)

    @tasks.each do |task|
      task.notify_deadline if days_left(task).between?(1, 10)
    end
  end
end

job = Sidekiq::Cron::Job.new(name: 'Task deadline - every day at 00:00', cron: '0 0 * * *', class: 'TaskDeadlineJob')

unless job.save
  puts job.errors # will return array of errors
end
