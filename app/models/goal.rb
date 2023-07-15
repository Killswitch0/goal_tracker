class Goal < ApplicationRecord
  include Searchable

  belongs_to :user
  belongs_to :category

  has_many :habits, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :notifications, through: :user

  has_noticed_notifications model_name: 'Notification'

  validates :name, presence: true, uniqueness: true,
            format: { with: /[A-Z]+[a-z]*/ },
            length: { minimum: 5, maximum: 50 }

  validates :description, presence: true,
            format: { with: /\A(.|\s)*[a-zA-Z]+(.|\s)*\z/ },
            length: { minimum: 7, maximum: 200 }

  validates :category_id, presence: true
  validates :color, presence: true, uniqueness: true
  validates :deadline, presence: true
  validates :color, presence: true

  def tasks_streak?
    return if self.tasks.completed.count == 0

    self.tasks.completed.count == self.tasks.count
  end

  def habits_streak?
    return if self.habits.completed_today.count == 0

    self.habits.completed_today.count == self.habits.count
  end
end
