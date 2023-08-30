class DashboardHabitsController < ApplicationController

  # GET /dashboard_habits/new
  #----------------------------------------------------------------------------
  def new
    @habit = Habit.new
  end

  # POST /dashboard_habits
  #----------------------------------------------------------------------------
  def create
    @habit = current_user.habits.build(task_params)

    if @habit.save
      flash[:noticed] = 'Habit has been successfully created.'
      redirect_to dashboard_path
    else
      flash[:noticed] = 'Habit was not created.'
      render :new, status: :unprocessable_entity
    end
  end

  # GET /dashboard_habits/1/complete
  #----------------------------------------------------------------------------
  def complete
    @habit = Habit.find(params[:id])
    @goal = @habit.goal

    if @habit.completed_today?
      @habit.complete_habit_today
      flash[:noticed] = 'Habit has been successfully completed.'
    else
      @habit.complete_habit_today
      flash[:noticed] = 'Habit has been successfully completed.'
    end

    redirect_to dashboard_path
  end

  private

  def task_params
    params.require(:habit).permit(
        :name,
        :goal_id,
        :description
      )
  end
end
