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

  def determine_winner
    user_tasks_count = {}

    goals.each do |goal|
      goal.tasks.each do |task|
        if task.complete?
          user_id = task.user

          user_tasks_count[user_id] ||= 0
          user_tasks_count[user_id] += 1
        end
      end
    end

    user_tasks_count.max_by { |_, count| count }&.first
  end

  def determine_category
    if tasks.count <= 3
      "low"
    elsif tasks.count <= 6
      "medium"
    else
      "hard"
    end
  end

  def check_creator(user)
    self.user == user
  end
end