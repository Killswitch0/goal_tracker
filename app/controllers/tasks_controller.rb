class TasksController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[index new create edit update destroy]
  before_action :set_task, only: %i[edit update destroy complete]

  helper_method :sort_column, :sort_direction

  # GET /goals/1/tasks
  #----------------------------------------------------------------------------
  def index
    @tasks = current_user.tasks.order("#{sort_column} #{sort_direction}")
    @completed_tasks = @tasks.where(complete: true, goal_id: @goal.id)
    @uncompleted_tasks = @tasks.where(complete: false, goal_id: @goal.id)
  end

  # GET /goals/1/tasks/new
  #----------------------------------------------------------------------------
  def new
    @task = Task.new
  end

  # GET /goals/1/tasks/1
  #----------------------------------------------------------------------------
  def show
    # @tasks = Task.find(params[:id])
  end

  # POST /goals/1/tasks
  #----------------------------------------------------------------------------
  def create
    @task = @goal.tasks.build(task_params)
    @task.user = current_user

    if @task.save
      flash[:noticed] = t('.success')
      redirect_to goal_path(@goal)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /goals/1/tasks/1
  #----------------------------------------------------------------------------
  def edit; end

  # PUT /goals/1/tasks/1
  #----------------------------------------------------------------------------
  def update
    if @task.update(task_params)
      redirect_to goal_path(@goal)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /goals/1/tasks/1
  #----------------------------------------------------------------------------
  def destroy
    @task.destroy
    redirect_to goal_task_path(@goal, @task)
  end

  # PUT /goals/1/tasks/1/complete
  #----------------------------------------------------------------------------
  def complete
    @goal = @task.goal
    
    if @task.complete?
      flash[:noticed] = t('.uncompleted')
      @task.update(complete: false, complete_date: nil)
    else
      flash[:noticed] = t('.completed')
      @task.update(complete: true, complete_date: Date.today)
    end

    redirect_to goal_path(@goal)
  end

  private

  def task_params
    params.require(:task).permit(
      :name,
      :complete,
      :deadline,
      :complete_date
    )
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "complete"
  end
end
