class HabitsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[ index new edit create update destroy ]

  def index
    @habits = current_user.habits
  end

  # def show
  #   @category = @goal.category_id
  #   @habit = Habit.find(params[:id])
  # end

  def new
    @habit = Habit.new
  end

  def edit
    @habit = Habit.find(params[:id])
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

  def update
    @habit = Habit.find(params[:id])

    respond_to do |format|
      if @habit.update(habit_params)
        redirect_to category_goal_path(@goal.category_id, @goal)
        format.js
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @habit = Habit.find(params[:id])
    @habit.destroy

    redirect_to goal_habit_path(@goal, @habit)
  end

  def complete
    @habit = Habit.find(params[:id])
    @goal = @habit.goal

    if @habit.keep?
      @habit.update_attribute(:keep, false)
      redirect_to category_goal_path(@goal.category_id, @goal)
    else
      @habit.update_attribute(:keep, true)
      redirect_to category_goal_path(@goal.category_id, @goal)
    end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def habit_params
    params.require(:habit).permit(:name, :description, :days_completed, :keep)
  end
end
