class DashboardController < ApplicationController
  before_action :redirect_user

  # GET /dashboard
  #----------------------------------------------------------------------------
  def show
    @all_goals = 
      Goal.includes(:user)
          .where(user: current_user)
          .order(complete: :asc)
    @all_tasks = filter_tasks
    @all_habits = filter_habits
  end

  private

  def filter_tasks
    if params.has_key?(:all_tasks)
      Task.includes(:user)
          .where(user: current_user)
          .order(complete: :asc)
    elsif params.has_key?(:open_tasks)
      Task.includes(:user)
          .where(user: current_user, complete: false)
          .order(complete: :asc)
    else
      Task.includes(:user)
          .where(user: current_user, complete: false)
          .order(complete: :asc)
    end
  end

  def filter_habits
    if params.has_key?(:all_habits)
      Habit.includes(:user)
           .left_joins(:completion_dates)
           .where(user: current_user)
           .order(
              Arel.sql(
                "CASE WHEN completion_dates.date IS NULL THEN 1
                  WHEN completion_dates.date = '#{Date.today}' THEN 3
                  ELSE 2 
                END"
              )
            ).uniq
    elsif params.has_key?(:open_habits)
      current_user.habits.not_completed_today
    else
      current_user.habits.not_completed_today
    end
  end
end
