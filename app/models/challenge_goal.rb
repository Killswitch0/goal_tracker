# == Schema information
#
# Table name: challenge_goals
#
#  id                  :integer          not null, primary key
#  user_id             :bigint           not null
#  goal_id             :bigint           not null
#  challenge_id        :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  challenge_user_id   :bigint           not null
#
# Indexes
#
#  index_challenge_goals_on_challenge_id     (challenge_id)
#  index_challenge_goals_on_challenge_user_id (challenge_user_id)
#  index_challenge_goals_on_goal_id          (goal_id)
#  index_challenge_goals_on_user_id          (user_id)
#

class ChallengeGoal < ApplicationRecord
  belongs_to :user
  belongs_to :goal
  belongs_to :challenge

  belongs_to :challenge_user

  validates :user_id, presence: true, uniqueness: { scope: :challenge_id, message: I18n.t('activerecord.errors.models.challenge_goal.one_goal') }
  validates :goal_id, presence: true
  validates :challenge_id, presence: true
end
