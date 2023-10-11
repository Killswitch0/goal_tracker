module Notifiable
  extend ActiveSupport::Concern

  def notify_create
    self.send_notification(params: notification_params)
  end

  def notify_deadline
    self.send_notification(subtype: 'Deadline', params: notification_params)
  end

  private

  def send_notification(subtype: '', params:)
    "#{self.class.name}#{subtype.capitalize}Notification".constantize.with(params).deliver_later(self.user)
  end

  # { habit: self, goal: goal }
  def notification_params
    raise NotImplementedError
  end
end