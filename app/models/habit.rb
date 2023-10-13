# == Schema information
#
# Table name: habits
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  days_completed :integer          default(0)
#  user_id        :bigint           not null
#  goal_id        :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_habits_on_goal_id  (goal_id)
#  index_habits_on_user_id  (user_id)

class Habit < ApplicationRecord
  include Searchable
  include Streakable
  include Notifiable::Base
  include Notifiable::Create
  include Notifiable::AlmostStreak
  include ValidationConstants

  belongs_to :user
  belongs_to :goal

  has_many :completion_dates, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id },
            format: {
              with: BASE_VALIDATION,
              message: :text_input
            },
            length: { minimum: 5, maximum: 45 }
  validates :description, presence: true

  after_create_commit :notify_create
  after_update_commit :notify_almost_streak, if: :almost_streak?

  before_destroy :cleanup_notifications

  has_noticed_notifications model_name: 'Notification'

  scope :completed_today, -> {
    joins(:completion_dates)
      .where('completion_dates.created_at >= ?',
             Date.today.beginning_of_day)
  }

  scope :not_completed_today, -> {
    today = Date.today
    left_joins(:completion_dates)
      .where('completion_dates.created_at IS NULL')
      .where.not(
        'EXISTS (
         SELECT 1
         FROM completion_dates
         WHERE habit_id = habits.id AND DATE(created_at) = ?)', today
    )
      .distinct
  }

  # For Streakable concern
  def completed_count
    goal.habits.completed_today.count
  end

  def completion_condition
    completion_dates.created_today.count.zero?
  end

  def completed_today?
    completion_dates.created_today.exists?
  end

  # group_by_month is the method of groupdate gem
  def completed_monthly
    completion_dates.group_by_month(:date).count
  end

  def completed_by_day
    completion_dates.group_by_period(:day, :date).count
  end

  def complete_habit_today
    if completion_dates.created_today.exists?
      update_attribute(:days_completed, self.days_completed -= 1)
      delete_completion_date
    else
      update_attribute(:days_completed, self.days_completed += 1)
      create_completion_date
    end
  end

  private

  def notification_params
    { habit: self, goal: goal }
  end

  def create_completion_date
    completion_date = CompletionDate.new(date: Time.now.to_date)
    completion_dates << completion_date # Habit.new.completion_dates.build
  end

  def delete_completion_date
    completion_dates.created_today.delete_all
  end
end
