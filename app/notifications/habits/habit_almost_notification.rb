# To deliver this notification:
#
# HabitAlmostNotification.with(post: @post).deliver_later(current_user)
# HabitAlmostNotification.with(post: @post).deliver(current_user)

class HabitAlmostNotification < ApplicationNotifications
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @goal = Goal.find(params[:habit][:goal_id])
    I18n.t('notifications.common.almost', target_name: @goal.name)
  end

  def to_parts
    @habit = Habit.find(params[:habit][:id])

    {
      user: t('you'),
      message: I18n.t('notifications.habit.almost.parts.message'),
      target: @habit.name
    }
  end

  def notif_avatar
    @goal = Goal.find(params[:habit][:goal_id])
    @goal.user
  end

  def url
    goal_path(Goal.find(params[:habit][:goal_id]), mark_as_read: 'true')
  end
end
