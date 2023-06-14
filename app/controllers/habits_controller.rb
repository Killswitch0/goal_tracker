class HabitsController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[ index new edit create update destroy ]

  helper_method :sort_column, :sort_direction

  def index
    @habits = current_user.habits
    @completed_habits = @habits.joins(:completion_dates).where(completion_dates: {created_at: Date.today.beginning_of_day..}).distinct
    @uncompleted_habits = @habits.left_joins(:completion_dates).where(completion_dates: {id: nil}).distinct
    #binding.pry
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
      render :new,status: :unprocessable_entity
    end
  end

  def update
    @habit = Habit.find(params[:id])

    respond_to do |format|
      if @habit.update(habit_params)
        redirect_to category_goal_path(@goal.category_id, @goal)
        format.html
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @habit = Habit.find(params[:id])
    @habit.destroy

    redirect_to goal_habit_path(@goal, @habit)
  end

  def completed_habit
    @habit = Habit.find(params[:id])
    @goal = @habit.goal

    if @habit.completed_today?
      flash[:noticed] = "You have already completed this habit today!"
      redirect_to goal_path(@goal)
    else
      @habit.complete_habit_today
      redirect_to goal_path(@goal)
    end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def habit_params
    params.require(:habit).permit(:name, :description, :days_completed, :completed)
  end
end
