class CalendarController < ApplicationController
  before_action :redirect_user

  # GET /calendar
  #----------------------------------------------------------------------------
  def show
    @habits =
      if params[:search]
        Habit.search(params[:search], current_user, Habit.table_name)
      else
        Habit.includes(:completion_dates).where(user: current_user)
      end

    @goals = current_user.goals

    return unless params[:goal_ids].present?

    @goals = @goals.where(id: params[:goal_ids])
    @habits = @habits.where(goal_id: params[:goal_ids])
  end
end
