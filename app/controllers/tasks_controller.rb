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
      redirect_to goal_path(@goal)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to goal_path(@goal)
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
      @task.update(complete: false, complete_date: nil)
    else
      flash[:noticed] = "Task has been successfully completed."
      @task.update(complete: true, complete_date: Date.today)
    end

    redirect_to goal_path(@goal)
  end

  private

  def task_params
    params.require(:task).permit(:name,
                                 :complete,
                                 :deadline,
                                 :complete_date
    )
  end

  def set_task
    @task ||= Task.find(params[:id])
  end

  def set_goal
    @goal ||= Goal.find(params[:goal_id])
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : "complete"
  end
end
