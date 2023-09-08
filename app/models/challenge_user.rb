# == Schema information
#
# Table name: goal_users
#
#  id         :integer          not null, primary key
#  confirm    :boolean          default(FALSE)
#  user_id    :bigint           not null
#  goal_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_goal_users_on_goal_id                          (goal_id)
#  index_goal_users_on_user_id_and_goal_id              (user_id,goal_id) UNIQUE
#  index_goal_users_on_user_id                          (user_id)

class ChallengeUser < ApplicationRecord
  include Notifyable

  belongs_to :user
  belongs_to :goal

  validates :goal_id, uniqueness: { scope: :user_id }

  after_create_commit :notify_create, if: :check_creator

  before_destroy :clean_up_notifications

  has_noticed_notifications model_name: 'Notification'

  # ignore invite notify if creator
  def check_creator
    self.user_id != self.goal.user_id
  end

  def creator?
    self.user_id == self.goal.user_id
  end

  private

  #
  def notification_params
    { goal_user: self, goal: self.goal }
  end

  def clean_up_notifications
    notifications_as_goal_user.destroy_all
  end
end
