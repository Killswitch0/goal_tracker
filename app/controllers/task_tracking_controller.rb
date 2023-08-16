class TaskTrackingController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    if params[:search]
      @tasks = Task.search(params[:search], current_user)
    else
      @tasks = current_user.tasks.order("#{sort_column} #{sort_direction}")
    end
  end
end
