# == Schema information
#
# Table name: challenges
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  deadline    :datetime
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_challenges_on_user_id  (user_id)

class Challenge < ApplicationRecord
  include Searchable
  include ValidationConstants

  belongs_to :user

  has_many :challenge_users, dependent: :destroy
  has_many :users, through: :challenge_users
  has_many :challenge_goals, dependent: :destroy
  has_many :goals, through: :challenge_goals

  validates :name, presence: true, format: { with: BASE_VALIDATION }
  validates :description, presence: true, format: { with: BASE_VALIDATION }

  validates :deadline, presence: true
  validate :min_deadline_period

  def determine_category_winners # TODO: - add test for it
    users_tasks = {}

    goals.each do |goal|
      user = goal.user
      user_tasks_count = user.tasks_count

      completed = user.tasks.completed.count == user_tasks_count

      users_tasks[user] = goal.tasks_count if completed || deadline < Time.zone.today
    end

    users_tasks
  end

  def check_creator(user)
    self.user == user
  end

  private

  def min_deadline_period
    return unless deadline
    return unless deadline < Date.today + 1.day

    errors.add(:deadline, I18n.t('activerecord.errors.models.challenge.min_period'))
  end
end
