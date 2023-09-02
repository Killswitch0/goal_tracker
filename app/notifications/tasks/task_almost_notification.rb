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
    "You almost made tasks streak in #{@goal.name.truncate(10)}"
  end

  def url
    goal_path(Goal.find(params[:task][:goal_id]), mark_as_read: 'true')
  end
end
