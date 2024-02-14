# To deliver this notification:
#
# GoalDeadlineNotification.with(post: @post).deliver_later(current_user)
# GoalDeadlineNotification.with(post: @post).deliver(current_user)

class GoalDeadlineNotification < ApplicationNotifications
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

  def message
    @goal = Goal.find(params[:goal][:id])
    t('notifications.common.left_for_complete', days: days_left(@goal), target_name: @goal.name)
  end

  def to_parts
    @goal = Goal.find(params[:goal][:id])

    {
      user: I18n.locale == :uk ? t('to_you') : t('you'),
      message: t('notifications.goal.deadline.parts.message', days: days_left(@goal)),
      target: @goal.name
    }
  end

  def notify_avatar
    @goal = Goal.find(params[:goal][:id])
    @goal.user
  end

  def url
    goal_path(Goal.find(params[:goal][:id]), mark_as_read: 'true')
  end
end
