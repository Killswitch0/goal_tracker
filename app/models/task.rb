class Task < ApplicationRecord
  belongs_to :goal

  validates :name, presence: true

  scope :completed, ->(goal) { where(complete: true, goal_id: goal.id) }

  def complete!
    self.complete = true
  end

  def incomplete!
    self.complete = false
  end
end
