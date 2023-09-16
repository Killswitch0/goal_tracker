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

  def determine_category_winners
    user_tasks_count = {}

    goals.each do |goal|
      user = goal.user
      completed = user.tasks.completed.count == user.tasks.count

      if completed || deadline < Date.today
        user_tasks_count[user] = goal.tasks.count
      end
    end

    user_tasks_count
  end

  def check_creator(user)
    self.user == user
  end
end