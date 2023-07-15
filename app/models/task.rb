class Task < ApplicationRecord
  include Streakable

  belongs_to :goal
  belongs_to :user

  validates :name, presence: true

  after_create_commit :notify_create
  after_update_commit :notify_almost_streak, if: :almost_streak?

  before_destroy :clean_up_notifications

  has_noticed_notifications model_name: 'Notification'

  scope :completed, -> { where(complete: true) }
  scope :uncompleted, -> { where(complete: false) }

  private

  def notify_create
    TaskNotification.with(task: self, goal: goal).deliver_later(goal.user)
  end

  def cleanup_notifications
    notifications_as_task.destroy_all
  end
end
