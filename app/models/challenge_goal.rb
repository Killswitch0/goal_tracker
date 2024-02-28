# == Schema Information
#
# Table name: challenge_goals
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  goal_id           :bigint           not null
#  challenge_id      :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  challenge_user_id :bigint           not null
#
class ChallengeGoal < ApplicationRecord
  belongs_to :user
  belongs_to :goal
  belongs_to :challenge

  belongs_to :challenge_user

  validates :user_id, presence: true, uniqueness: { scope: :challenge_id, message: :one_goal }
  validates :goal_id, presence: true
  validates :challenge_id, presence: true

  validate :check_deadline

  private

  #----------------------------------------------------------------------------
  def check_deadline
    return unless Time.zone.today >= challenge.deadline

    errors.add(:goal_id,
               I18n.t('activerecord.errors.models.challenge_goal.challenge_ended'))
  end
end
