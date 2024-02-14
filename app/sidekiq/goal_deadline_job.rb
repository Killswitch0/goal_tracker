class GoalDeadlineJob
  include Sidekiq::Job

  include ApplicationHelper

  queue_as :default

  def perform(*_args)
    @goals = Goal.where('deadline > ?', Time.now)

    @goals.each do |goal|
      goal.notify_deadline if days_left(goal).between?(1, 10)
    end
  end
end

job = Sidekiq::Cron::Job.new(name: 'Goal deadline - every day at 00:00', cron: '0 0 * * *', class: 'GoalDeadlineJob')

unless job.save
  puts job.errors # will return array of errors
end
