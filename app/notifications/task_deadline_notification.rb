# To deliver this notification:
#
# TaskDeadlineNotification.with(post: @post).deliver_later(current_user)
# TaskDeadlineNotification.with(post: @post).deliver(current_user)

class TaskDeadlineNotification < ApplicationNotifications
  # Add your delivery methods

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
    @task = Task.find(params[:task][:id])
    I18n.t('notifications.common.left_for_complete', days: days_left(@task), target_name: @task.name)
  end

  def notify_avatar
    @task = Task.find(params[:task][:id])
    @task.user
  end

  def url
    goal_path(Goal.find(params[:task][:goal_id]), mark_as_read: 'true')
  end
end
