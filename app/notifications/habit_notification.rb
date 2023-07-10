# To deliver this notification:
#
# HabitNotification.with(post: @post).deliver_later(current_user)
# HabitNotification.with(post: @post).deliver(current_user)

class HabitNotification < Noticed::Base
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
    @goal = Goal.find(params[:habit][:goal_id])
    @habit = Habit.find(params[:habit][:id])
    @user = User.find(@habit.user_id)
    "#{@user.name} created #{@habit.name.truncate(10)} in #{@goal.name.truncate(10)}"
  end

  def url
    goal_path(Goal.find(params[:habit][:goal_id]), mark_as_read: 'true')
  end
end