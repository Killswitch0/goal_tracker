class GroupsController < ApplicationController
  before_action :redirect_user
  before_action :set_invite, only: %i[index show new]
  before_action :set_group, only: %i[create_invitation confirm_invitation decline_invitation destroy]
  before_action :set_invitation, only: %i[confirm_invitation decline_invitation leave show]

  def index
    @groups = Group.where(user_id: current_user)
    groups_in_user_groups = Group.includes(:user_groups)
    @creator_groups = groups_in_user_groups.where(user_groups: { user_id: current_user.id })
    @confirmed_groups = groups_in_user_groups.where(user_groups: { user_id: current_user.id, confirm: true })
  end

  def show
    @group = Group.find_by(id: params[:id])

    require_invitation

    if @group
      @members = User.joins(:user_groups).where(user_groups: { confirm: true, group_id: @group.id }).distinct
      mark_notifications_as_read if params[:mark_as_read] == 'true'
    else
      flash[:danger] = "Something go wrong"
      redirect_to root_path
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.build(group_params)
    @group.user_id = current_user.id

    if @group.save
      current_user.user_groups << UserGroup.new(group: @group, confirm: true)
      flash[:noticed] = "Group has been successfully created."
      redirect_to group_path(@group)
    else
      flash[:danger] = "Group has not successfully created."
      render :new
    end
  end

  def destroy
    @group.destroy
    flash[:noticed] = "Group was successfully destroyed."
    redirect_to groups_path
  end

  def create_invitation
    invited_user = User.find_by(email: params[:email])

    if invited_user
      @invitation = UserGroup.new(group: @group, user: invited_user)

      if @invitation.save
        flash[:noticed] = "Invitation sent to #{invited_user.email}"
        redirect_to group_path @group
      elsif @invitation.present?
        flash[:danger] = "User already got invite"
        redirect_to group_path @group
      else
        flash[:danger] = "Failed to send invitation"
        redirect_to group_path @group
      end
    else
      flash[:danger] = "User not found"
      redirect_to group_path @group
    end
  end

  def confirm_invitation
    if @invitation
      @invitation.update_attribute(:confirm, true)
      flash[:noticed] = "You have accepted invitation and joined to #{@invitation.group.name} group."
      redirect_to group_path @group
    else
      flash[:danger] = "Invitation not found"
      redirect_to group_path @group
    end
  end

  def decline_invitation
    if @invitation
      @invitation.update_attribute(:confirm, false)
      @invitation.destroy
      flash[:noticed] = "You have ignored invitation to #{@invitation.group.name} group."
      redirect_to group_path @group
    else
      flash[:danger] = "Invitation not found"
      redirect_to group_path @group
    end
  end

  def leave
    @invitation.destroy
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :group_id, :user_id)
  end

  def require_invitation
    @group = Group.find_by(id: params[:id])
    return if @group.blank?

    invitation = UserGroup.find_by(group_id: @group, user: current_user)
    redirect_to root_path unless invitation
  end

  def mark_notifications_as_read
    return unless current_user

    notifications_to_mark_as_read = @group.notifications.where(recipient: current_user)
    notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def set_invitation
    @invitation = UserGroup.find_by(user: current_user)
  end

  def set_invite
    @invites = current_user.user_groups.where(confirm: false)
  end
end
