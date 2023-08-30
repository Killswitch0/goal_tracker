class GoalInvitationsController < ApplicationController
  before_action :redirect_user
  before_action :set_invite, only: %i[index show new]
  before_action :set_group, only: %i[create_invitation confirm_invitation decline_invitation destroy]
  before_action :set_invitation, only: %i[confirm_invitation decline_invitation leave show]

  def index
    @user_goals = Goal.where(user_id: current_user)
    goals_in_goal_users = Goal.includes(:goal_users)
    @creator_goals = goals_in_goal_users.where(goal_users: { user_id: current_user.id })
    @confirmed_goals = goals_in_goal_users.where(goal_users: { user_id: current_user.id, confirm: true })
  end

  def show
    @goal = Goal.find_by(id: params[:id])

    require_invitation

    if @goal
      @members = User.joins(:goal_users).where(goal_users: { confirm: true, goal_id: @goal.id }).distinct
      mark_notifications_as_read if params[:mark_as_read] == 'true'
    else
      flash[:danger] = "Something go wrong"
      redirect_to root_path
    end
  end

  def new; end

  def create
    @goal = current_user.groups.build(group_params)
    @goal.user_id = current_user.id

    if @goal.save
      current_user.goal_users << GoalUser.new(goal: @goal, confirm: true)
      flash[:noticed] = "Group has been successfully created."
      redirect_to goal_path(@goal)
    else
      flash[:danger] = "Group has not successfully created."
      render :new
    end
  end

  def create_invitation
    invited_user = User.find_by(email: params[:email])

    if invited_user
      @invitation = GoalUser.new(goal: @goal, user: invited_user)

      if @invitation.save
        flash[:noticed] = "Invitation sent to #{invited_user.email}"
        redirect_to goal_path @goal
      elsif @invitation.present?
        flash[:danger] = "User already got invite"
        redirect_to goal_path @goal
      else
        flash[:danger] = "Failed to send invitation"
        redirect_to goal_path @goal
      end
    else
      flash[:danger] = "User not found"
      redirect_to goal_path @goal
    end
  end

  def confirm_invitation
    if @invitation
      @invitation.update_attribute(:confirm, true)
      flash[:noticed] = "You have accepted invitation and joined to #{@invitation.goal.name} group."
      redirect_to goal_path @goal
    else
      flash[:danger] = "Invitation not found"
      redirect_to goal_path @goal
    end
  end

  def decline_invitation
    if @invitation
      @invitation.update_attribute(:confirm, false)
      @invitation.destroy
      flash[:noticed] = "You have ignored invitation to #{@invitation.goal.name} group."
      redirect_to goal_path @goal
    else
      flash[:danger] = "Invitation not found"
      redirect_to goal_path @goal
    end
  end

  def leave
    @invitation.destroy
    redirect_to goals_path
  end

  private

  def goal_params
    params.require(:goal).permit(
      :name,
      :goal_id,
      :user_id
    )
  end

end
