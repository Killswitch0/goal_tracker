class DashboardController < ApplicationController
  before_action :redirect_user

  # GET /dashboard
  #----------------------------------------------------------------------------
  def show
    @all_goals = current_user.goals
                             .order(complete: :asc)
    @all_tasks = filter_tasks
    @all_habits = filter_habits
  end

  private

  def filter_tasks
    @tasks = current_user.tasks

    not_completed = @tasks.where(complete: false)

    if params.has_key?(:all_tasks)
      @tasks.order(complete: :desc)
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
      Habit.sorted_by_completion(current_user)
    elsif params.has_key?(:open_habits)
      not_completed
    else
      not_completed
    end
  end
end
