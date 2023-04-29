class Habit < ApplicationRecord
  belongs_to :user
  belongs_to :goal

  validates :name, presence: true
  validates :description, presence: true
end
