class Task < ApplicationRecord
  belongs_to :goal
  belongs_to :user

  validates :name, presence: true

  scope :completed, -> { where(complete: true) }
  scope :uncompleted, -> { where(complete: false) }
end
