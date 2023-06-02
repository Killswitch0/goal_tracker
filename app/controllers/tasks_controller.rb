class TasksController < ApplicationController
  before_action :redirect_user

  helper_method :sort_column, :sort_direction

  def index
    @goal = Goal.find(params[:goal_id])
    @tasks = Task.order(sort_column + ' ' + sort_direction)
  end

  def new
    @goal = Goal.find(params[:goal_id])
    @task = Task.new
  end

  def show
    # @task = Task.find(params[:id])
  end

  def create
    @goal = Goal.find(params[:goal_id])
    @task = @goal.tasks.build(task_params)
    @task.user = current_user

    if @task.save
      redirect_to category_goal_path(@goal.category_id, @goal)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @goal = Goal.find(params[:goal_id])
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to category_goal_path(@task.goal.category_id, @task.goal)
      respond_to do |format|
        format.html
      end
    end
  end

  def destroy
    @goal = Goal.find(params[:goal_id])
    @task = Task.find(params[:id])

    @task.destroy
    redirect_to goal_task_path(@goal, @task)
  end

  def complete
    @task = Task.find(params[:id])
    @goal = @task.goal
    if @task.complete?
      @task.update_attribute(:complete, false)
      redirect_to category_goal_path(@goal.category_id, @goal)
    else
      @task.update_attribute(:complete, true)
      redirect_to category_goal_path(@goal.category_id, @goal)
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :complete, :deadline)
  end
end
