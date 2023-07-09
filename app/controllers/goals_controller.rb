class GoalsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[ show edit update destroy ]

  helper_method :sort_column, :sort_direction

  def index
    if params[:search]
      @goals = Goal.search(params[:search], current_user)
    else
      @goals = current_user.goals.order(complete: :asc)
    end
  end

  def show
    @tasks = @goal.tasks.order(sort_column + ' ' + sort_direction)
    @habits = @goal.habits.order(sort_column + ' ' + sort_direction)

    mark_notifications_as_read if params[:mark_as_read] == 'true'
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user
    @category = @goal.category

    respond_to do |format|
      if @goal.save
        flash[:noticed] = "Goal was successfully created."
        redirect_to category_goal_path(@category, @goal)
        format.html
      else
        flash[:danger] = "Goal was not created."
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # @category = Category.find(params[:category_id])
    # @goal = @category.goals.find_by(id: params[:id])
  end

  def update
    @category = @goal.category_id

    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to category_goal_path(@category, @goal) }
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
    params.require(:goal).permit(:name, :description, :category_id, :days_completed, :deadline, :complete, :color)
  end

  def set_category
    @category ||= Category.find(params[:category_id])
  end

  def set_goal
    @goal ||= Goal.find(params[:id])
  end

  def mark_notifications_as_read
    if current_user
      notifications_to_mark_as_read = @goal.notifications_as_goal.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
end
