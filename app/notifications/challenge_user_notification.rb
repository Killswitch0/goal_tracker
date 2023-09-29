# To deliver this notification:
#
# UserGroupNotification.with(post: @post).deliver_later(current_user)
# UserGroupNotification.with(post: @post).deliver(current_user)

class ChallengeUserNotification < ApplicationNotifications
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
    @challenge = Challenge.find(params[:challenge_user][:challenge_id])
    @challenge_user = ChallengeUser.find(params[:challenge_user][:id])
    @user = User.find(params[:challenge_user][:user_id])
    "You've been invited to the #{@challenge.name} challenge"
  end

  def url
    challenge_path(Challenge.find(params[:challenge_user][:challenge_id]), mark_as_read: 'true')
  end
end
