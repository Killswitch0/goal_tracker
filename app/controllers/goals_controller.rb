class GoalsController < ApplicationController
  before_action :redirect_user
  before_action :set_invite, only: %i[index show new]
  before_action :set_goal, only: %i[create_invitation confirm_invitation decline_invitation show update destroy]
  before_action :set_invitation, only: %i[confirm_invitation decline_invitation leave show]

  helper_method :sort_column, :sort_direction

  # GET /goals
  #----------------------------------------------------------------------------
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

  # GET /goals/new
  #----------------------------------------------------------------------------
  def new
    @goal = Goal.new
  end

  # GET /goals/1
  #----------------------------------------------------------------------------
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

  # POST /goals
  #----------------------------------------------------------------------------
  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user

    respond_to do |format|
      if params[:goal][:category_id].present? && params[:goal][:category_attributes][:name].present?
        flash[:danger] = t('.category_must_exist')
        format.html { render :new, status: :unprocessable_entity }
      elsif @goal.save
        current_user.goal_users << GoalUser.new(goal: @goal, confirm: true)
        flash[:noticed] = t('.success')
        redirect_to goal_path(@goal)
        format.html
      else
        flash[:danger] = t('.fail')
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # POST /goals/1/create_invitation
  #----------------------------------------------------------------------------
  def create_invitation
    @goal = Goal.find(params[:id])
    invited_user = User.find_by(email: params[:email])

    if invited_user
      @invitation = GoalUser.new(goal: @goal, user: invited_user)

      if @invitation.save
        flash[:noticed] = "Invitation sent to #{invited_user.email}"
      elsif @invitation.present?
        flash[:danger] = t('.already')
      else
        flash[:danger] = t('.fail')
      end
    else
      flash[:danger] = "User not found"
    end

    redirect_to goal_path(@goal)
  end

  # PUT /goals/1/confirm_invitation
  #----------------------------------------------------------------------------
  def confirm_invitation
    if @invitation
      @invitation.update_attribute(:confirm, true)
      flash[:noticed] = t('.success', goal_name: @invitation.goal.name)
    else
      flash[:danger] = t('.fail')
    end
  end

  # DELETE /goals/1/decline_invitation
  #----------------------------------------------------------------------------
  def decline_invitation
    if @invitation
      @invitation.destroy
      flash[:noticed] = t('.success', goal_name: @invitation.goal.name)
    else
      flash[:danger] = t('.fail')
    end

    redirect_to goal_path(@goal)
  end

  # DELETE /goals/1/leave
  #----------------------------------------------------------------------------
  def leave
    @invitation.destroy
    redirect_to goals_path
  end

  # GET /goals/1/edit
  def edit; end

  # PUT /goals/1
  #----------------------------------------------------------------------------
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

  # DELETE /goals/1
  #----------------------------------------------------------------------------
  def destroy
    @goal.destroy
    flash[:noticed] = t('.success')
    redirect_to goals_path
  end

  private

  def goal_params
    params.require(:goal).permit(
      :name,
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
    @category = Category.find(params[:category_id])
  end

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def mark_notifications_as_read
    return unless current_user

    notifications_to_mark_as_read = @goal.notifications_as_goal.where(recipient: current_user)
    notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
  end

  # Requires goal invitation to get access
  def require_invitation
    @goal = Goal.find_by(id: params[:id])
    return if @goal.blank?

    invitation = GoalUser.find_by(goal_id: @goal, user: current_user)
    redirect_to root_path unless invitation
  end

  def set_invitation
    @invitation = GoalUser.find_by(user: current_user)
  end

  def set_invite
    @invites ||= current_user.goal_users.where(confirm: false)
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "complete"
  end
end
