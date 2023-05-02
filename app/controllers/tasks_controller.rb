class TasksController < ApplicationController
  before_action :redirect_user

  def index
    @goal = Goal.find(params[:goal_id])
    @tasks = current_user.tasks
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
      render :new
    end
  end

  def edit
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to category_goals_path(@task.goal.category_id, @task.goal)
      respond_to do |format|
        format.js
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
