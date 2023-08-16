class Task < ApplicationRecord
  include Streakable
  include Notifyable
  include Searchable

  belongs_to :goal
  belongs_to :user

  validates :name, presence: true

  after_create_commit :notify_create
  after_update_commit :notify_almost_streak, if: :almost_streak?

  before_destroy :cleanup_notifications

  has_noticed_notifications model_name: 'Notification'

  scope :completed, -> { where(complete: true) }
  scope :uncompleted, -> { where(complete: false) }

  private

  # for Streakable concern
  def completed_count
    goal.tasks.where(complete: true).size
  end

  def completed_condition
    complete?
  end

  def notification_params
    { task: self, goal: goal }
  end

  def cleanup_notifications
    notifications_as_task.destroy_all
  end
end
