class CalendarController < ApplicationController
  def show
    @habits = if params[:search]
                Habit.search(params[:search], current_user)
              else
                current_user.habits.includes(:completion_dates)
              end
    @goals = current_user.goals.includes(:habits)
  end
end
