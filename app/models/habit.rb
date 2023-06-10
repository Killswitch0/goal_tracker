class Habit < ApplicationRecord
  belongs_to :user
  belongs_to :goal

  has_many :completion_dates, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  scope :completed, ->(goal, user) { where(keep: true, goal_id: goal.id, user_id: user.id) }
  scope :uncompleted, ->(goal, user) { where(keep: false, goal_id: goal.id, user_id: user.id) }

  def habit_completed_today?(date)
    self.completion_dates.each do |completion_date|
      return true if completion_date.date.localtime == date
    end
  end

  def complete_habit_today
    self.update_attribute(:days_completed, self.days_completed += 1)
    self.update_attribute(:keep, true)

    completion_date = CompletionDate.new(date: Time.now.localtime)
    self.completion_dates << completion_date
    completion_date.save!
  end

end
