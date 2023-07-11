class Habit < ApplicationRecord
  include Searchable

  belongs_to :user
  belongs_to :goal

  has_many :completion_dates, dependent: :destroy

  validates :name, presence: true, uniqueness: true
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

  def completed_today?
    completion_dates.created_today.exists?
  end

  # group_by_day is the method of groupdate gem
  def completed_monthly
    completion_dates.group_by_month(:created_at).count
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

  def create_completion_date
    completion_date = CompletionDate.new(date: Time.now.to_date)
    completion_dates << completion_date # Habit.new.completion_dates.build
  end

  def delete_completion_date
    completion_dates.created_today.delete_all
  end

  ### methods for notice ###
  #
  # Checks if the habits is in "almost streak" state
  # when true then notify_almost_streak
  def almost_streak?
    all_habits = goal.habits.count
    return if all_habits == 1

    completed = goal.habits.completed_today.count
    (all_habits - completed).between?(2, 4) &&
      all_habits != 0 &&
      completion_dates.created_today.count.zero?
  end

  def notify_create
    HabitNotification.with(habit: self, goal: goal).deliver_later(goal.user)
  end

  def notify_almost_streak
    HabitAlmostNotification.with(habit: self, goal: goal).deliver(goal.user)
  end

  def cleanup_notifications
    notifications_as_habit.destroy_all
  end
end
