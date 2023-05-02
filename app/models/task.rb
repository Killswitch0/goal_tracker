class Task < ApplicationRecord
  belongs_to :goal
  belongs_to :user

  validates :name, presence: true

  scope :completed, ->(goal) { where(complete: true, goal_id: goal.id) }
  scope :uncompleted, ->(goal) { where(complete: false, goal_id: goal.id) }

end
