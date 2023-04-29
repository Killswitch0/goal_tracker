class TasksController < ApplicationController
  def index
    @tasks = Task.all
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
      redirect_to category_goal_path(@task.goal.category_id, @task.goal)
      respond_to do |format|
        format.js
      end
    end
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
    params.require(:task).permit(:name, :complete)
  end
end
