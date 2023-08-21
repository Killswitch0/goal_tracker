class TaskTrackingController < ApplicationController
  helper_method :sort_column, :sort_direction

  # GET /task_tracking
  #----------------------------------------------------------------------------
  def show
    if params[:search]
      @tasks = Task.search(params[:search], current_user)
    else
      @tasks = current_user.tasks.order("#{sort_column} #{sort_direction}")
    end
  end

  private

  def sort_column(column = 'deadline', model = 'task')
    super
  end

  def sort_column
    Goal.column_names.include?(params[:sort]) ? params[:sort] : "deadline"
  end
end
