class GroupUser < ApplicationRecord
  include Notifyable

  belongs_to :user
  belongs_to :group

  validates :group_id, uniqueness: { scope: :user_id }

  after_create_commit :notify_create, if: :check_creator

  before_destroy :clean_up_notifications

  has_noticed_notifications model_name: 'Notification'

  # ignore invite notify if creator
  def check_creator
    self.user_id != self.group.user_id
  end

  def creator?
    self.user_id == self.group.user_id
  end

  private

  def notification_params
    { group_user: self, group: self.group }
  end

  def clean_up_notifications
    notifications_as_group_user.destroy_all
  end
end
