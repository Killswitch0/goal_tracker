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
  belongs_to :user

  has_many :challenge_users, dependent: :destroy
  has_many :users, through: :challenge_users

  has_many :challenge_goals, dependent: :destroy
  has_many :goals, through: :challenge_goals

  def determine_category_winners
    user_tasks_count = {}

    goals.each do |goal|
      user = goal.user
      user_tasks_count[user] = goal.tasks.count
    end

    user_tasks_count
  end

  def check_creator(user)
    self.user == user
  end
end