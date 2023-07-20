class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :group_id, uniqueness: { scope: :user_id }

  after_create_commit :send_notification_create, if: :check_creator

  before_destroy :clean_up_notifications

  has_noticed_notifications model_name: 'Notification'

  # ignore invite notify if creator
  def check_creator
    self.user_id != self.group.user_id
  end

  private

  def send_notification_create
    UserGroupNotification.with(user_group: self, group: self.group).deliver_later(self.user)
  end

  def clean_up_notifications
    notifications_as_user_group.destroy_all
  end
end
