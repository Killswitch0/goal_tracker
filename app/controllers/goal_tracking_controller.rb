class GoalTrackingController < ApplicationController
  before_action :redirect_user

  helper_method :sort_column, :sort_direction

  # GET /goal_tracking
  #----------------------------------------------------------------------------
  def show
    if params[:search]
      @goals = Goal.search(params[:search], current_user, Goal.table_name)
    else
      @goals = current_user.goals.order("#{sort_column} #{sort_direction}")
    end
  end

  private

  def sort_column(column = 'deadline', model = 'goal')
    super
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
