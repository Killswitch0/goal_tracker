class CalendarController < ApplicationController
  before_action :redirect_user

  # GET /calendar
  #----------------------------------------------------------------------------
  def show
    @habits = 
      if params[:search]
        Habit.search(params[:search], current_user, Habit.table_name)
      else
        current_user.habits.includes(:completion_dates)
      end

    @goals = current_user.goals.includes(:habits)
  end
end
