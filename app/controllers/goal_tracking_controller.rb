class GoalTrackingController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    if params[:search]
      @goals = Goal.search(params[:search], current_user)
    else
      @goals = current_user.goals.order("#{sort_column} #{sort_direction}")
    end
  end

  private

  def sort_column
    Goal.column_names.include?(params[:sort]) ? params[:sort] : "deadline"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
