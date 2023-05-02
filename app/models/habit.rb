class Habit < ApplicationRecord
  belongs_to :user
  belongs_to :goal

  validates :name, presence: true
  validates :description, presence: true

  scope :completed, ->(goal, user) { where(keep: true, goal_id: goal.id, user_id: user.id) }
  scope :uncompleted, ->(goal, user) { where(keep: false, goal_id: goal.id, user_id: user.id) }

end
