module Notifyable
  private

  def send_notification_create(params)
    "#{self.class.name}Notification".constantize.with(params).deliver_later(self.user)
  end

  def notify_create
    self.send_notification_create(notification_params)
  end

  # { habit: self, goal: goal }
  def notification_params
    raise NotImplementedError
  end
end