# == Schema information
#
# Table name: challenge_users
#
#  id           :integer          not null, primary key
#  confirm      :boolean          default(FALSE)
#  user_id      :bigint           not null
#  challenge_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_challenge_users_on_challenge_id  (challenge_id)
#  index_challenge_users_on_user_id      (user_id)


class ChallengeUser < ApplicationRecord
  include Notifiable::Base
  include Notifiable::Create

  belongs_to :user
  belongs_to :challenge

  has_many :challenge_goals, dependent: :destroy

  validates :challenge_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  after_create_commit :notify_create, if: :check_creator

  before_destroy :cleanup_notifications

  has_noticed_notifications model_name: 'Notification'

  # ignore invite notify if creator
  def check_creator
    self.user_id != self.challenge.user_id
  end

  def creator?
    self.user_id == self.challenge.user_id
  end

  private

  def notification_params
    { challenge_user: self, challenge: self.challenge }
  end
end
