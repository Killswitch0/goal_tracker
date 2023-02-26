class GoalsController < ApplicationController
  before_action :redirect_user

  def index
    @goals = Goal.all
  end

  def show
    @goal = Goal.find(params[:id])
    @habit = @goal.habits.build
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = current_user.goals.build(goal_params)

    if @goal.save
      flash[:success] = "Goal was successfully created."
      redirect_to @goal
    else
      flash[:notice] = "Goal was not created."
      render :new
    end
  end

  def edit
  end

  private

  def goal_params
    params.require(:goal).permit(:name, :description, :days_completed)
  end
end
