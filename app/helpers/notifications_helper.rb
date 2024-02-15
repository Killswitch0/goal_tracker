module NotificationsHelper
  def notif_limit(notif)
    notif >= 0 ? notif : '99+'
  end
end
