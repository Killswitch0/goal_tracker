class CalendarController < ApplicationController
  def show
    @habits = if params[:search]
                Habit.search(params[:search], current_user)
              else
                current_user.habits
              end
  end
end
