# To deliver this notification:
#
# HabitAlmostNotification.with(post: @post).deliver_later(current_user)
# HabitAlmostNotification.with(post: @post).deliver(current_user)

class HabitAlmostNotification < Noticed::Base
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
    "You almost make streak in #{@goal.name.truncate(10)}! Let's GO!"
  end

  def url
    goal_path(Goal.find(params[:habit][:goal_id]), mark_as_read: 'true')
  end
end
