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
  include Notifyable::Base
  include Notifyable::Create
  include Notifyable::Deadline
  include Notifyable::AlmostStreak
  include Searchable
  include ValidationConstants

  belongs_to :goal, counter_cache: true
  belongs_to :user, counter_cache: true

  # TODO: - !!! REALIZE -> https://github.com/magnusvk/counter_culture
  counter_culture :goal, column_name: proc { |model| model.complete? ? 'tasks_completed_count' : nil }

  after_update_commit :check_goal_completion

  validates :name, presence: true,
                   format: {
                     with: BASE_VALIDATION,
                     message: :text_input
                   }

  validates :deadline, presence: true, comparison: { greater_than: Time.zone.today }

  after_create_commit :notify_create
  after_update_commit :notify_almost_streak, if: :almost_streak?

  before_destroy :cleanup_notifications

  has_noticed_notifications model_name: 'Notification'

  scope :completed, -> { where(complete: true) }
  scope :uncompleted, -> { where(complete: false) }

  private

  def check_goal_completion
    if goal.tasks.all?(&:complete?)
      goal.update(complete: true)
    else
      goal.update(complete: false)
    end
  end

  # for Streakable concern
  def completion_count
    goal.tasks_completed_count
  end

  def completion_condition
    complete?
  end

  def notification_params
    { task: self, goal: }
  end
end
