class CalendarController < ApplicationController
  def show
    @habits = if params[:search]
                Habit.search(params[:search], current_user)
              else
                current_user.habits.includes(:completion_dates)
              end
  end
end
