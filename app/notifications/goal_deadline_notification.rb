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
    I18n.t('notifications.common.left_for_complete', days: days_left(@goal), target_name: @goal.name) # TODO - finish helper methods to easy render html
  end

  def notify_avatar
    @goal = Goal.find(params[:goal][:id])
    @goal.user
  end

  def url
    goal_path(Goal.find(params[:goal][:id]), mark_as_read: 'true')
  end
end
