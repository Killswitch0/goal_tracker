# == Schema Information
#
# Table name: challenge_users
#
#  id           :bigint           not null, primary key
#  confirm      :boolean          default(FALSE)
#  user_id      :bigint           not null
#  challenge_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class ChallengeUser < ApplicationRecord
  include Notifyable::Base
  include Notifyable::Create

  belongs_to :user
  belongs_to :challenge

  has_many :challenge_goals, dependent: :destroy

  validates :challenge_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  after_create_commit :notify_create, if: :not_creator?

  before_destroy :cleanup_notifications

  has_noticed_notifications model_name: 'Notification'

  #----------------------------------------------------------------------------
  def not_creator? 
    user_id != challenge.user_id
  end

  #----------------------------------------------------------------------------
  def creator?
    user_id == challenge.user_id
  end

  private

  # Params for Notifyable::Base send_notification
  #----------------------------------------------------------------------------
  def notification_params
    { challenge_user: self, challenge: }
  end
end
