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

    %Q{
      #{tag.strong @user.name} invited you to take part in Challenge #{tag.a @challenge.name, href: challenge_path(@challenge, mark_as_read: 'true'), class: 'strong'}

      #{tag.div(
          button_to(t('accept'), confirm_invitation_challenge_path(@challenge), method: :patch, class: 'btn btn-primary btn-sm') +
          button_to(t('decline'), decline_invitation_challenge_path(@challenge), method: :patch, class: 'btn btn-danger btn-sm mx-1'),
          class: 'buttons-list start'
        )
      }

    }.html_safe
  end

  def notify_avatar
    @user = User.find(params[:challenge_user][:user_id])
  end

  def url
    challenge_path(Challenge.find(params[:challenge_user][:challenge_id]), mark_as_read: 'true')
  end
end
