# To deliver this notification:
#
# TaskAlmostNotification.with(post: @post).deliver_later(current_user)
# TaskAlmostNotification.with(post: @post).deliver(current_user)

class TaskAlmostNotification < ApplicationNotifications
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
    @goal = Goal.find(params[:task][:goal_id])

    t('notifications.task.almost.full_message', target: @goal.name)
  end

  def to_parts
    @goal = Goal.find(params[:task][:goal_id])

    {
      user: t('you'),
      message: t('notifications.task.almost.parts.message'),
      target: @goal.name
    }
  end

  def notif_avatar
    @goal = Goal.find(params[:task][:goal_id])
    @goal.user
  end

  def url
    goal_path(Goal.find(params[:task][:goal_id]), mark_as_read: 'true')
  end
end
