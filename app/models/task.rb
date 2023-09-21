# == Schema information
#
# Table name: tasks
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  complete     :boolean          default(FALSE)
#  goal_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  deadline     :datetime
#  complete_date :date
#
# Indexes
#
#  index_tasks_on_goal_id  (goal_id)
#  index_tasks_on_user_id  (user_id)
#

class Task < ApplicationRecord
  include Streakable
  include Notifyable
  include Searchable
  include ValidationConstants

  belongs_to :goal
  belongs_to :user

  after_update_commit :check_goal_completion

  validates :name, presence: true,
            format: {
              with: BASE_VALIDATION,
              message: I18n.t('activerecord.errors.base.validations.messages.text_input')
            }

  after_create_commit :notify_create
  after_update_commit :notify_almost_streak, if: :almost_streak?

  before_destroy :cleanup_notifications

  has_noticed_notifications model_name: 'Notification'

  scope :completed, -> { where(complete: true) }
  scope :uncompleted, -> { where(complete: false) }

  private

  def check_goal_completion
    if goal.tasks.all? { |task| task.complete? }
      goal.update(complete: true)
    else
      goal.update(complete: false)
    end
  end

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
