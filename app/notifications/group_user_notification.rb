# To deliver this notification:
#
# UserGroupNotification.with(post: @post).deliver_later(current_user)
# UserGroupNotification.with(post: @post).deliver(current_user)

class GroupUserNotification < Noticed::Base
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
    @group = Group.find(params[:group_user][:group_id])
    @user_group = GroupUser.find(params[:group_user][:id])
    @user = User.find(params[:group_user][:user_id])
    "Your invite to #{@group.name}"
  end

  def url
    group_path(Group.find(params[:group_user][:group_id]), mark_as_read: 'true')
  end
end
