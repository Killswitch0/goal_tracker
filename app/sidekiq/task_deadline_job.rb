class TaskDeadlineJob
  include Sidekiq::Job
  include Sidekiq::Worker

  include ApplicationHelper

  queue_as :default

  def perform(*args)
    @tasks = Task.where('deadline > ?', Time.now)

    @tasks.each do |task|
      if days_left(task).between?(1, 10)
        task.notify_deadline
      end
    end
  end
end

job = Sidekiq::Cron::Job.new(name: 'Task deadline - every day at 00:00', cron: '0 0 * * *', class: 'TaskDeadlineJob')

unless job.save
  puts job.errors # will return array of errors
end
