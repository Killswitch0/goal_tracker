# To deliver this notification:
#
# UserGroupNotification.with(post: @post).deliver_later(current_user)
# UserGroupNotification.with(post: @post).deliver(current_user)

class GoalUserNotification < Noticed::Base
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
    @goal = Goal.find(params[:goal_user][:goal_id])
    @goal_user = GoalUser.find(params[:goal_user][:id])
    @user = User.find(params[:goal_user][:user_id])
    "Your invite to #{@goal.name}"
  end

  def url
    goal_path(Goal.find(params[:goal_user][:goal_id]), mark_as_read: 'true')
  end
end
