class DashboardHabitsController < ApplicationController
  def new
    @habit = Habit.new
  end

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

  def complete
    @habit = Habit.find(params[:id])
    @goal = @habit.goal

    if @habit.completed_today?
      @habit.complete_habit_today
      flash[:noticed] = 'Your habit successfully uncompleted.'
    else
      @habit.complete_habit_today
      flash[:noticed] = 'Your habit successfully completed.'
    end

    redirect_to dashboard_path
  end

  private

  def task_params
    params.require(:habit).permit(:name,
                                  :goal_id,
                                  :description
    )
  end
end
