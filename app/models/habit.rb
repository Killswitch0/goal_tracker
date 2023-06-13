class Habit < ApplicationRecord
  belongs_to :user
  belongs_to :goal

  has_many :completion_dates, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  scope :completed, -> (goal) { joins(:completion_dates)
                                  .where('completion_dates.created_at >= ? AND habits.goal_id = ?',
                                         Date.today.beginning_of_day, goal.id)
  }
  scope :uncompleted, -> (goal) { where(completed: false, goal_id: goal.id) }

  def complete_habit_today
    self.update_attribute(:days_completed, self.days_completed += 1)
    self.update_attribute(:completed, true)

    completion_date = CompletionDate.new(date: Time.now.localtime)
    self.completion_dates << completion_date
  end

  def completed_today?
    completion_dates.created_today.exists?
  end

  # def habit_completed_today?(date)
  #   self.completion_dates.each do |completion_date|
  #     return true if completion_date.date.localtime == date
  #   end
  # end
end
