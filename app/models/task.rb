class Task < ApplicationRecord
  belongs_to :goal
  belongs_to :user

  validates :name, presence: true

  after_create_commit :notify_create
  after_create_commit :notify_almost_streak, if: :almost_streak?
  after_update_commit :notify_almost_streak, if: :almost_streak?

  before_destroy :clean_up_notifications

  has_noticed_notifications model_name: 'Notification'

  scope :completed, -> { where(complete: true) }
  scope :uncompleted, -> { where(complete: false) }

  private

  def almost_streak?
    all_tasks = goal.tasks.count
    return if all_tasks == 1

    completed = goal.tasks.where(complete: true).size
    (all_tasks - completed).between?(1, 4) &&
      all_tasks != 0 &&
      self.complete?
  end

  def notify_create
    TaskNotification.with(task: self, goal: goal).deliver(goal.user)
  end

  def notify_almost_streak
    TaskAlmostNotification.with(task: self, goal: goal).deliver(goal.user)
  end

  def cleanup_notifications
    notifications_as_task.destroy_all
  end
end
