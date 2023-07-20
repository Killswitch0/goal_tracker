# To deliver this notification:
#
# UserGroupNotification.with(post: @post).deliver_later(current_user)
# UserGroupNotification.with(post: @post).deliver(current_user)

class UserGroupNotification < Noticed::Base
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
    @group = Group.find(params[:user_group][:group_id])
    @user_group = UserGroup.find(params[:user_group][:id])
    @user = User.find(params[:user_group][:user_id])
    "Your invite to #{@group.name}"
  end

  def url
    group_path(Group.find(params[:user_group][:group_id]), mark_as_read: 'true')
  end
end
