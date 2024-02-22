class DashboardTasksController < ApplicationController
  # GET /dashboard_tasks/new
  #----------------------------------------------------------------------------
  def new
    @task = Task.new
  end

  # POST /dashboard_tasks
  #----------------------------------------------------------------------------
  def create
    @task = current_user.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        flash[:noticed] = t('tasks.create.success')
        format.html { redirect_to dashboard_path }
      else
        flash[:noticed] = t('tasks.create.fail')
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # PUT dashboard_tasks/1/complete
  #----------------------------------------------------------------------------
  def complete
    @task = Task.find(params[:id])

    if @task.complete?
      flash[:noticed] = t('tasks.complete.uncompleted')
      @task.update(complete: false, complete_date: nil)
    else
      flash[:noticed] = t('tasks.complete.completed')
      @task.update(complete: true, complete_date: Date.today)
    end

    redirect_to dashboard_path
  end

  private

  def task_params
    params.require(:task).permit(
      :name,
      :complete,
      :goal_id,
      :deadline,
      :complete_date
    )
  end
end
