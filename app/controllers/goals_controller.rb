class GoalsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[create_invitation confirm_invitation decline_invitation show update destroy]

  helper_method :sort_column, :sort_direction

  # GET /goals
  #----------------------------------------------------------------------------
  def index
    @goals = if params[:search]
               Goal.search(params[:search], current_user, Goal.table_name)
             elsif params[:filter]
               Goal.where(category_id: params[:filter], user: current_user)
             elsif params[:sort]
               Goal.all.order("#{sort_column} #{sort_direction}")
             else
               current_user.goals.order(complete: :asc)
             end

    @user_goals = Goal.where(user_id: current_user)
  end

  # GET /goals/new
  #----------------------------------------------------------------------------
  def new
    @goal = Goal.new
  end

  # GET /goals/1
  #----------------------------------------------------------------------------
  def show
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
        flash[:noticed] = t('.success')
        redirect_to goal_path(@goal)
        format.html
      else
        flash[:danger] = t('.fail')
        format.html { render :new, status: :unprocessable_entity }
      end
    end
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

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "complete"
  end
end
