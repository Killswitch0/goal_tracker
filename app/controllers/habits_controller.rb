class HabitsController < ApplicationController
  before_action :set_goal, only: %i[ show new create ]

  def index
  end

  def show
    @habit = Habit.find(params[:id])
  end

  def new
    @habit = Habit.new
  end

  def create
    @habit = @goal.habits.build(habit_params)
    @habit.user = current_user

    if @habit.save
      redirect_to category_goal_path(@goal.category_id, @goal)
    else
      render :new
    end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def habit_params
    params.require(:habit).permit(:name, :description, :days_completed)
  end
end
