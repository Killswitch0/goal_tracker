# == Schema Information
#
# Table name: habits
#
#  id             :bigint           not null, primary key
#  name           :string
#  description    :text
#  days_completed :integer          default(0)
#  user_id        :bigint           not null
#  goal_id        :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Habit < ApplicationRecord
  include Searchable
  include Streakable
  include Notifyable::Base
  include Notifyable::Create
  include Notifyable::AlmostStreak
  include ValidationConstants

  belongs_to :user
  belongs_to :goal

  has_many :completion_dates, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: { scope: :user_id },
                   format: {
                     with: BASE_VALIDATION,
                     message: :text_input
                   },
                   length: {
                     minimum: 5,
                     maximum: 45
                   }

  validates :description, presence: true

  after_create_commit :notify_create
  after_update_commit :notify_almost_streak, if: :almost_streak?

  before_destroy :cleanup_notifications

  has_noticed_notifications model_name: 'Notification'

  scope :completed_today, lambda {
    today = Time.zone.today

    includes(:completion_dates)
      .where('completion_dates.date >= ?', today)
      .references(:completion_dates)
  }

  scope :not_completed_today, lambda { |user|
    today = Time.zone.today

    left_joins(:completion_dates)
      .where(habits: { user_id: user.id })
      .where.not(
        'EXISTS (
          SELECT 1
          FROM completion_dates
          WHERE habit_id = habits.id AND DATE(created_at) = ?
        )', today
      )
      .distinct
  }

  scope :sorted_by_completion, lambda { |user|
    today = Time.zone.today

    joins(:completion_dates)
      .where(
        'habits.user_id = ? AND completion_dates.date = ?',
        user.id, today
      )
      .order(
        Arel.sql(
          "CASE WHEN completion_dates.date = '#{today}' THEN 1
            WHEN completion_dates.date IS NULL THEN 3
          ELSE 2
          END"
        )
      )
      .references(:completion_dates)
      .uniq
  }

  # Top habits by completions count this month
  scope :top_this_month, lambda { |user|
    includes(:completion_dates)
      .where(
        habits: { user_id: user },
        completion_dates: {
          date: Date.current.all_month
        }
      )
      .group('habits.id, completion_dates.id')
      .order('COUNT(completion_dates.id) DESC')
      .uniq
  }

  # Returns an array with habit name and completion dates data
  #
  # [{"name":"Morning exercise","data":{"2024-02-01":1}}]
  #----------------------------------------------------------------------------
  def self.habits_with_completion_period_data(habits, period, range: nil)
    habits.map do |habit|
      completion_data = habit.completion_dates

      {
        name: habit.name,
        data: if completion_data.presence
                completion_data.group_by_period(period, :date, range:).count
              else
                0
              end
      }
    end
  end

  # For Streakable concern
  #----------------------------------------------------------------------------
  def completion_count
    goal.habits.completed_today.count
  end

  def completion_condition
    completion_dates.created_today.count.zero?
  end

  def completed_today?
    completion_dates.created_today.exists?
  end

  # Creates or deletes a habit completion date record within the current day
  #----------------------------------------------------------------------------
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

  # For Notifyable::Base send_notification
  #----------------------------------------------------------------------------
  def notification_params
    { habit: self, goal: }
  end

  # Creates completion date record for habit
  #----------------------------------------------------------------------------
  def create_completion_date
    completion_date = CompletionDate.new(date: Time.zone.now.to_date)
    completion_dates << completion_date # Habit.new.completion_dates.build
  end

  # Deletes habit completion date record for current day
  #----------------------------------------------------------------------------
  def delete_completion_date
    completion_dates.created_today.delete_all
  end
end
