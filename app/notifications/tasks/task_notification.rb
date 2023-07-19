# To deliver this notification:
#
# TaskNotification.with(post: @post).deliver_later(current_user)
# TaskNotification.with(post: @post).deliver(current_user)

class TaskNotification < Noticed::Base
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
    @goal = Goal.find(params[:task][:goal_id])
    @task = Task.find(params[:task][:id])
    @user = User.find(params[:task][:user_id])
    "#{@user.name} created #{@task.name.truncate(10)} tasks in #{@goal.name.truncate(10)}"
  end

  def url
    goal_path(Goal.find(params[:task][:goal_id]), mark_as_read: 'true')
  end
end
