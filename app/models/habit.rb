class Habit < ApplicationRecord
  include Searchable

  belongs_to :user
  belongs_to :goal

  has_many :completion_dates, dependent: :destroy
  has_many :notifications, through: :user, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  after_create_commit :notify_recipient
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
      self.update_attribute(:days_completed, self.days_completed -= 1)
      delete_completion_date
    else
      self.update_attribute(:days_completed, self.days_completed += 1)
      create_completion_date
    end
  end

  # def habit_completed_today?(date)
  #   self.completion_dates.each do |completion_date|
  #     return true if completion_date.date.localtime == date
  #   end
  # end

  private

  def create_completion_date
    completion_date = CompletionDate.new(date: Time.now.to_date)
    self.completion_dates << completion_date # Habit.new.completion_dates.build
  end

  def delete_completion_date
    self.completion_dates.created_today.delete_all
  end

  def notify_recipient
    HabitNotification.with(habit: self, goal: goal).deliver_later(goal.user)
  end

  def cleanup_notifications
    notifications_as_habit.destroy_all
  end
end
