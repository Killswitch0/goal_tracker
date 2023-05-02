class GoalsController < ApplicationController
  before_action :redirect_user
  before_action :set_category, only: %i[]

  def index
    @goals = current_user.goals
  end

  def show
    @goal = Goal.find(params[:id])
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
        flash[:success] = "Goal was successfully created."
        redirect_to category_goal_path(@category, @goal)
        format.html
      else
        flash[:notice] = "Goal was not created."
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # @category = Category.find(params[:category_id])
    # @goal = @category.goals.find_by(id: params[:id])

    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    @category = @goal.category_id

    respond_to do |format|
      if @goal.update(goal_params)
        format.js { redirect_to category_goal_path(@goal)}
      else
        format.js { render :edit }
      end
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def goal_params
    params.require(:goal).permit(:name, :description, :category_id, :days_completed, :deadline, :complete)
  end
end
