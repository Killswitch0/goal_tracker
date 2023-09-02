# == Schema information
#
# Table name: goals
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :string(255)
#  days_completed :integer          default(0)
#  user_id        :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deadline       :datetime
#  complete       :boolean          default(FALSE)
#  category_id    :bigint           not null
#  color          :string(255)
#
# Indexes
#
#  index_goals_on_category_id  (category_id)
#  index_goals_on_user_id      (user_id)
#

class Goal < ApplicationRecord
  include Searchable
  include ValidationConstants

  belongs_to :user
  belongs_to :category

  has_many :habits, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :goal_users, dependent: :destroy
  has_many :users, through: :goal_users

  # noticed gem association
  has_many :notifications, through: :users

  has_noticed_notifications model_name: 'Notification'

  accepts_nested_attributes_for :category, reject_if: proc { |attributes| attributes['name'].blank? }

  validates :name, presence: true, uniqueness: true,
            format: {
              with: BASE_VALIDATION,
              message: "must starts with letter and end with letter or digit."
            },
            length: { minimum: 5, maximum: 50 }

  validates :description, presence: true,
            format: {
              with: BASE_VALIDATION,
              message: 'allows only letters(uppercase and lowercase), numbers, commas, dots, dashes and colons.' },
            length: { minimum: 7, maximum: 200 }

  validates :category_id, presence: false
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
