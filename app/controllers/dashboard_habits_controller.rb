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

    respond_to do |format|        
      if @habit.save
        flash[:noticed] = t('habits.create.success')
        format.html { redirect_to dashboard_path }
      else
        flash[:danger] = t('habits.create.fail')
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # GET /dashboard_habits/1/complete
  #----------------------------------------------------------------------------
  def complete
    @habit = Habit.find(params[:id])
    @goal = @habit.goal

    flash[:noticed] = if @habit.completed_today?
                        t('habits.complete.uncompleted')
                      else
                        t('habits.complete.completed')
                      end

    @habit.complete_habit_today

    redirect_to dashboard_path
  end

  private

  def task_params
    params.require(:habit).permit(:name, :goal_id, :description)
  end
end
