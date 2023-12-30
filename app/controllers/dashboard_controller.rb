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
    @task = Task.includes(:user)
            .where(user: current_user)

    not_completed = 
      @task.where(complete: false)

    if params.has_key?(:all_tasks)
      @task.order(complete: :desc)
    elsif params.has_key?(:open_tasks)
      not_completed
    else
      not_completed
    end
  end

  def filter_habits
    not_completed = 
      Habit.not_completed_today(current_user)

    if params.has_key?(:all_habits)
      Habit.includes(:user)
           .left_joins(:completion_dates)
           .where(user: current_user)
           .order(
              Arel.sql(
                "CASE WHEN completion_dates.date = '#{Date.today}' THEN 1
                  WHEN completion_dates.date IS NULL THEN 3
                  ELSE 2 
                END"
              )
            ).uniq
    elsif params.has_key?(:open_habits)
      not_completed
    else
      not_completed
    end
  end
end
