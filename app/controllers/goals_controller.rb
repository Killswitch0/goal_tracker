class GoalsController < ApplicationController
  before_action :redirect_user
  before_action :set_invite, only: %i[index show new]
  before_action :set_goal, only: %i[create_invitation confirm_invitation decline_invitation show update destroy]
  before_action :set_invitation, only: %i[confirm_invitation decline_invitation leave show]

  helper_method :sort_column, :sort_direction

  def index
    @goals = if params[:search]
               Goal.search(params[:search], current_user)
             elsif params[:filter]
               Goal.where(category_id: params[:filter], user: current_user)
             else
               current_user.goals.order(complete: :asc)
             end

    @user_goals = Goal.where(user_id: current_user)
    goals_in_goal_users = Goal.includes(:goal_users)
    @creator_goals = goals_in_goal_users.where(goal_users: { user_id: current_user.id })
    @confirmed_goals = goals_in_goal_users.where(goal_users: { user_id: current_user.id, confirm: true })
  end

  def show
    require_invitation

    if @goal
      @members = User.joins(:goal_users).where(goal_users: { confirm: true, goal_id: @goal.id }).distinct
      mark_notifications_as_read if params[:mark_as_read] == 'true'
    else
      flash[:danger] = "Something go wrong"
      redirect_to root_path
    end

    @tasks = if params[:sort]
               @goal.tasks.order(sort_column + ' ' + sort_direction)
             else
               @goal.tasks.order(complete: :asc)
             end

    @habits = @goal.habits.not_completed_today

    mark_notifications_as_read if params[:mark_as_read] == 'true'
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user

    respond_to do |format|
      if params[:goal][:category_id].present? && params[:goal][:category_attributes][:name].present?
        flash[:danger] = "Choose Category or create new."
        format.html { render :new, status: :unprocessable_entity }
      elsif @goal.save
        current_user.goal_users << GoalUser.new(goal: @goal, confirm: true)
        flash[:noticed] = "Goal was successfully created."
        redirect_to goal_path(@goal)
        format.html
      else
        flash[:danger] = "Goal was not created."
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def create_invitation
    @goal = Goal.find(params[:id])
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

  def edit
    # @category = Category.find(params[:category_id])
    # @goal = @category.goals.find_by(id: params[:id])
  end

  def update
    @category = @goal.category_id

    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to goal_path(@goal) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @goal.destroy
    flash[:noticed] = "Goal was successfully destroyed."
    redirect_to goals_path
  end

  private

  def goal_params
    params.require(:goal).permit(:name,
                                 :description,
                                 :category_id,
                                 :days_completed,
                                 :deadline,
                                 :complete,
                                 :color,
                                 category_attributes: [:name, :user_id]
    )
  end

  def set_category
    @category ||= Category.find(params[:category_id])
  end

  def set_goal
    @goal ||= Goal.find(params[:id])
  end

  def mark_notifications_as_read
    return unless current_user

    notifications_to_mark_as_read = @goal.notifications_as_goal.where(recipient: current_user)
    notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
  end

  # goal invites
  def require_invitation
    @goal = Goal.find_by(id: params[:id])
    return if @goal.blank?

    invitation = GoalUser.find_by(goal_id: @goal, user: current_user)
    redirect_to root_path unless invitation
  end

  def set_invitation
    @invitation ||= GoalUser.find_by(user: current_user)
  end

  def set_invite
    @invites ||= current_user.goal_users.where(confirm: false)
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "complete"
  end
end
