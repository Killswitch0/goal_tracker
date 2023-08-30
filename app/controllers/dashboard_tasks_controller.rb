class DashboardTasksController < ApplicationController

  # GET /dashboard_tasks/new
  #----------------------------------------------------------------------------
  def new
    @task = Task.new
    @task.build_goal
  end

  # POST /dashboard_tasks
  #----------------------------------------------------------------------------
  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:noticed] = 'Task has been successfully created.'
      redirect_to dashboard_path
    else
      flash[:noticed] = 'Task was not created.'
      render :new, status: :unprocessable_entity
    end
  end

  # PUT dashboard_tasks/1/complete
  #----------------------------------------------------------------------------
  def complete
    @task = Task.find(params[:id])

    @goal = @task.goal
    if @task.complete?
      flash[:noticed] = 'Task has been successfully uncompleted.'
      @task.update(complete: false, complete_date: nil)
    else
      flash[:noticed] = 'Task has been successfully completed.'
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
