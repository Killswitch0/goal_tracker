class Goal < ApplicationRecord
  include Searchable
  
  AVAILABLE_COLORS = [['Purple', 'rgb(140,8,246)'],
                      ['Blue', 'rgb(17,85,253)'],
                      ['Red', 'rgb(255,18,12)'],
                      ['Pink', 'rgb(255,125,253)'],
                      ['Cyan', 'rgb(1,240,253)'],
                      ['Yellow', 'rgb(255,255,33)'],
                      ['Gold', 'rgb(252,206,24)'],
                      ['Midnight blue', 'rgb(14,31,82)']]

  belongs_to :user
  belongs_to :category

  has_many :habits, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: true,
            format: { with: /[A-Z]+[a-z]*/ },
            length: { minimum: 5, maximum: 50 }

  validates :description, presence: true,
            format: { with: /\A(.|\s)*[a-zA-Z]+(.|\s)*\z/ },
            length: { minimum: 7, maximum: 200 }

  validates :category_id, presence: true
  validates :color, presence: true
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
