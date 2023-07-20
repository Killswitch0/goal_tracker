class TasksController < ApplicationController
  before_action :redirect_user
  before_action :set_goal, only: %i[index new create edit destroy]
  before_action :set_task, only: %i[edit update destroy complete]

  helper_method :sort_column, :sort_direction

  def index
    @tasks = current_user.tasks.order("#{sort_column} #{sort_direction}")
    @completed_tasks = @tasks.where(complete: true, goal_id: @goal.id)
    @uncompleted_tasks = @tasks.where(complete: false, goal_id: @goal.id)
  end

  def new
    @task = Task.new
  end

  def show
    # @tasks = Task.find(params[:id])
  end

  def create
    @task = @goal.tasks.build(task_params)
    @task.user = current_user

    if @task.save
      flash[:noticed] = "Task has been successfully created."
      redirect_to category_goal_path(@goal.category_id, @goal)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to category_goal_path(@task.goal.category_id, @task.goal)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to goal_task_path(@goal, @task)
  end

  def complete
    @goal = @task.goal
    if @task.complete?
      flash[:noticed] = "Task has been successfully uncompleted."
      @task.update_attribute(:complete, false)
    else
      flash[:noticed] = "Task has been successfully completed."
      @task.update_attribute(:complete, true)
    end

    redirect_to category_goal_path(@goal.category_id, @goal)
  end

  private

  def task_params
    params.require(:task).permit(:name, :complete, :deadline)
  end

  def set_task
    @task ||= Task.find(params[:id])
  end

  def set_goal
    @goal ||= Goal.find(params[:goal_id])
  end
end
